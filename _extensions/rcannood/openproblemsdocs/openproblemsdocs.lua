
return {
  {
    Callout = function(callout)
      local calloutContent = pandoc.utils.stringify(callout.content)
      return pandoc.RawBlock("html", "<Callout variant=\"" .. callout.type .. "\">" .. calloutContent .. "</Callout>")
    end
  }
}
