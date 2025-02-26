local function jsx(content)
  return pandoc.RawBlock("markdown", content)
end

-- Check for the custom format (IMPORTANT:  This is the correct way)
local function isCustomMdxOutput()
  return true
  -- local name =  param("quarto-custom-format", "")
  -- print("Shortcode: ", name)
  -- return name == "custommdx-md"
end

quarto._quarto.ast.add_renderer("Callout", isCustomMdxOutput, function(node)
  return jsx(('<Callout variant="%s">\n%s</Callout>\n'):format(
    node.type:gsub("callout%-", ""),                      -- Extract "note", "tip", etc.
    pandoc.write(pandoc.Pandoc(node.content), "markdown") -- Convert content to Markdown
  ))
end)

quarto._quarto.ast.add_renderer("Tabset", isCustomMdxOutput, function(node)
  local groupId = ""
  local group = node.attr.attributes["group"]
  if group then
    groupId = ([[ group="%s"]]):format(group)
  end

  local tabValues = {}
  for i = 1, #node.tabs do
    tabValues[i] = pandoc.utils.stringify(node.tabs[i].title)
  end

  local tabs = pandoc.Div({})
  tabs.content:insert(jsx("<Tabset" .. groupId .. ' values={["' .. table.concat(tabValues, '","') .. '"]}>'))

  for i = 1, #node.tabs do
    local content = node.tabs[i].content
    local title = node.tabs[i].title
    tabs.content:insert(jsx(([[<Tab value="%s">]]):format(pandoc.utils.stringify(title))))
    if type(content) == "table" then
      tabs.content:extend(content)
    else
      tabs.content:insert(content)
    end
    tabs.content:insert(jsx("</Tab>"))
  end

  tabs.content:insert(jsx("</Tabset>"))
  return tabs
end)

quarto._quarto.ast.add_renderer("FloatRefTarget", isCustomMdxOutput, function(float)
  float = quarto.doc.crossref.decorate_caption_with_crossref(float)

  -- note: is there a better way to do this?
  local captionMd = pandoc.write(pandoc.Pandoc({ float.caption_long }), FORMAT, PANDOC_WRITER_OPTIONS)

  return pandoc.Blocks({
    jsx(('<Figure id="%s" caption="%s">'):format(float.identifier, captionMd)),
    pandoc.Div(quarto.utils.as_blocks(float.content)),
    jsx('</Figure>')
  })
end)

-- Remove simple HTML comments from text
local function RawInline(el)
    el.text = el.text:gsub("<!--.*-->", "")
  return el
end

-- Remove simple HTML comments from text
local function RawBlock(el)
  el.text = el.text:gsub("<!--.*-->", "")
  return el
end

return {
  {
    RawInline = RawInline,
    RawBlock = RawBlock,
  }
}
