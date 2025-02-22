
return {
  {
    -- wrap all divs with class="callout" in a Callout element
    Callout = function(el)
      local calloutContent = pandoc.utils.stringify(el.content)
      return pandoc.RawBlock("html", "<Callout variant=\"" .. el.type .. "\">\n" .. calloutContent .. "\n</Callout>")
    end,
    -- wrap all codeblocks with class="mermaid" in a Mermaid element
    CodeBlock = function(el)
      if el.attr.classes:includes("mermaid") then
        local escapedTest = el.text:gsub("`", "\\`"):gsub("&#10;", "\n"):gsub("&#10;", "\n")
        return pandoc.RawBlock("html", "<MermaidDiagram chart={`\n" .. escapedTest .. "`} />")
      end
    end,
    -- remove simple html comments from text
    RawBlock = function(el)
      el.text = el.text:gsub("<!--.*-->", "")
      return el
    end,
  }
}
