import click
import os
import re
import parse

@click.group()
def cli():
    pass
  
class Template():
    """Compile an text into a template function"""

    def __init__(self, text):
        self.delimiter = re.compile(r'{%(.*?)%}', re.DOTALL)
        self.tokens = self.compile(text)

    def compile(self, text):
        tokens = []
        for index, token in enumerate(self.delimiter.split(text)):
            if index % 2 == 0:
                # plain string
                if token:
                    tokens.append((False, token.replace('%\\}', '%}').replace('{\\%', '{%')))
            else:
                # code block
                # find out the indentation
                lines = token.replace('{\\%', '{%').replace('%\\}', '%}').splitlines()
                indent = min([len(l) - len(l.lstrip()) for l in lines if l.strip()])
                realigned = '\n'.join(l[indent:] for l in lines)
                tokens.append((True, compile(realigned, '<tempalte> %s' % realigned[:20], 'exec')))
        return tokens


    def render(self, context = None, **kw):
        """Render the template according to the given context"""
        global_context = {}
        if context:
            global_context.update(context)
        if kw:
            global_context.update(kw)

        # add function for output
        def emit(*args):
            result.extend([str(arg) for arg in args])
        def fmt_emit(fmt, *args):
            result.append(fmt % args)

        global_context['emit'] = emit
        global_context['fmt_emit'] = fmt_emit

        # run the code
        result = []
        for is_code, token in self.tokens:
            if is_code:
                exec(token, global_context)
            else:
                result.append(token)
        return ''.join(result)

    # make instance callable
    __call__ = render

def prepare_post(filepath):
    post = open(filepath, "r").read()
    # Remove google doc formatting (margin, white bg, fixed width)
    post = re.sub("background-color:#[0-9a-fA-F]+;max-width:\\d*\\.?\\d*pt;padding:(\\d*\\.?\\d*pt\\s?)+", "", post)
    # Make text readable on white background
    post = post.replace("color:#000000", "color:#E4E5E6")
    return post

def generate_post(post, title, filepath):
    template = Template(open("blog.template", "r").read())
    res = template({
        'title': title,
        'post': post,
        'imagePath': filepath,
        'homePath': '../..'
    })
    return res

def generate_beforebody(title):
    template = Template(open("beforebody.template", "r").read())
    res = template({
        'title': title,
        'homePath': '../..'
    })
    return res

@cli.command(name='bb')
@click.option('-t', '--title')
def write_beforebody(title):
    title = parse.lookup_title(title)
    result = generate_beforebody(title)

    f = open("beforebody.html", "w")
    f.write(result)
    f.close()

@cli.command(name='posts')
def do_all_posts():
    # Iterate through all the blog post folders
    for f in os.scandir("."):
        if f.is_dir():
            title = f.name # Use folder name as title
            rootPath = f.path # root of blog post folder
            for file in os.listdir(rootPath):
                filepath = os.path.join(rootPath, file)
                _, file_extension = os.path.splitext(filepath)
                if file_extension == '.html':
                    post = prepare_post(filepath)
                    result = generate_post(post, title, filepath)

                    f = open(file, "w")
                    f.write(result)
                    f.close()
            print("Done: " + title)

if __name__ == '__main__':
    cli()