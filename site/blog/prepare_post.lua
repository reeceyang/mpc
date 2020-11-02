local header_template_default = [[
<!DOCTYPE html>
<html lang="en-us" style="" class=" no-touchevents">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5">
      <title>${title} - MIT MPC</title>
      <link rel="stylesheet" href="${homePath}/assets/css/blog.css">
   </head>
   <body class="Body--post">

<div class="Header">
   <div class="Header-content">
      <div class="Header-top">
         <a class="Logo" href="${homePath}/" aria-label="MIT MPC, back to homepage">
            <div class="Logo-textBigLetter"> <span aria-hidden="true"> 
               MIT Music Production Collaborative
            </span> </div> </a>
         <div class="Menu">
            <a class="Menu-link " href="${homePath}/index.html"> About </a>
               <span aria-hidden="true">/</span>
            <a class="Menu-link " href="${homePath}/news.html"> Archive </a>
         </div>
      </div>
      <h1 class="Header-title Header-title--page" style="transform: translateY(0px); opacity: 1;"> <span aria-hidden="true">
         ${title}
         </span>
         <div class="Header-author">
            By ${author}
         </div>
      </h1>
   </div>
   <div class="Header-angle Header-angle--left"></div>
   <div class="Header-angle Header-angle--right"></div>
</div>
   <div class="Post Container">
]]

local header_template_links = [[
<!DOCTYPE html>
<html lang="en-us" style="" class=" no-touchevents">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5">
      <title>${title} - MIT MPC</title>
      <link rel="stylesheet" href="${homePath}/assets/css/blog.css">
   </head>
   <body class="Body--post">

<div class="Header">
   <div class="Header-content">
      <div class="Header-top">
         <a class="Logo" href="${homePath}/" aria-label="MIT MPC, back to homepage">
            <div class="Logo-textBigLetter"> <span aria-hidden="true"> 
               MIT Music Production Collaborative
            </span> </div> </a>
         <div class="Menu">
            <a class="Menu-link " href="${homePath}/index.html"> About </a>
               <span aria-hidden="true">/</span>
            <a class="Menu-link " href="${homePath}/news.html"> Archive </a>
         </div>
      </div>
      <h1 class="Header-title Header-title--page" style="transform: translateY(0px); opacity: 1;"> <span aria-hidden="true">
         ${title}
         </span>
      </h1>
   </div>
   <div class="Header-angle Header-angle--left"></div>
   <div class="Header-angle Header-angle--right"></div>
</div>
   <div class="Post Container">
]]

local metavars = {
    imagePath = "",
    homePath = "..",
    title = "lorem ipsum",
    author = "Karthik Nair"
}
function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

-- Passing information from a higher level (e.g., metadata)
function Meta (meta)
    for k, v in pairs(meta) do
        metavars[k] = v
    end
end

-- Filter with these function if the target format is HTML
if FORMAT:match 'html' then
  local lightboxes = { }
  local thumbnail_template = [[
    <!-- The link that, when clicked, will display the image in full screen -->
    <a href="#${id}">
      <img src="${src}" alt="Thumbnail" style="width:${width}; height:${height}; object-fit: contain;">
    </a>
  ]]
  local captioned_thumbnail_template = [[
    <figure>
      <a href="#${id}">
        <img src="${src}" alt="Thumbnail" style="width:${width}; height:${height}; object-fit: contain;">
      </a>
      <figcaption aria-hidden="true">${caption}
      </figcaption>
    </figure>
  ]]
  local lightbox_template = [[
    <!-- The full screen image, hidden by default  -->
    <a href="#_" class="lightbox" id="${id}">
      <img src="${src}" alt="Fullscreen">
    </a>
  ]]

  function Image (elem)
    -- Use object-fit style to align image with screen size
    local vars = {
      width = elem.attributes['width'],
      height = 'auto',
      -- height = elem.attributes['height'],
      id = pandoc.utils.sha1(elem.src),
      caption = pandoc.utils.stringify(elem.caption),
      src = elem.src,
    }
    local thumbnail = interp(thumbnail_template, vars)
    if #vars['caption'] > 0 then
      thumbnail = interp(captioned_thumbnail_template, vars)
    end
    local lightbox = interp(lightbox_template, vars)
    
    lightboxes[#lightboxes+1] = lightbox -- Add lightbox to end
    return pandoc.RawInline('html', thumbnail)
  end

  -- Set header template according to metadata
  function select_header_template()
    if metavars['header'] == 'links' then
      return header_template_links
    end
    return header_template_default
  end

  -- Append header template
  function Pandoc (doc)
    local meta = doc.meta
    local blocks = doc.blocks
    -- Replacing placeholders with their metadata value using interp
    local header_template = select_header_template()
    lightboxes[#lightboxes+1] = interp(header_template, metavars)
    blocks:insert(1, pandoc.RawBlock('html', table.concat(lightboxes,"\n")))
    pandoc.walk_block(doc.blocks[1], {replace})
    return pandoc.Pandoc(blocks, meta)
  end

  -- If Para starts with iframe tag, escape the Para to render content correctly
  function Para (elem)
    local content = pandoc.utils.stringify(elem.content)
    local iframe = '<iframe'
    if content:sub(1, #iframe) == iframe then
        return pandoc.RawBlock('html', content)
    end
    return elem
  end

  -- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
  function dump(o)
     if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
           if type(k) ~= 'number' then k = '"'..k..'"' end
           s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
     else
        return tostring(o)
     end
  end
end

-- Filter Para with this function if the target format is markdown
if FORMAT:match 'markdown' then
  local function is_caption_after_image(cap, img)
    return cap and cap.t == 'Para'
      and img and img.t == 'Para'
      -- there must be only a single img content val, and it must have
      -- tag 'Image'
      and #img.content == 1
      and img.content[1].t == 'Image'
  end

  function Pandoc (doc)
    -- Go from end to start to avoid problems with shifting indices.
    local blocks = doc.blocks
    for i = #blocks, 2, -1 do
      if is_caption_after_image(blocks[i], blocks[i-1]) then
        -- sets caption
        blocks[i-1].content[1].caption = blocks[i].content
        -- sets dimensions
        blocks[i-1].content[1].attributes['width'] = '100%'
        blocks[i-1].content[1].attributes['height'] = 'auto'
        blocks:remove(i)
      end
    end
    return doc
  end
end