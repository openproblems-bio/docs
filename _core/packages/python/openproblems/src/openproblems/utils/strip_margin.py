def strip_margin(text: str, symbol: str = "\\|") -> str:
  """
  Strip margin from a string

  Args:
      text (str): A character vector.
      symbol (str): The margin symbol to strip.
  
  Returns:
      str: A character vector with the margin stripped.

  Example:

    ```python
    strip_margin("
      |hello_world:
      |  this_is: "a yaml"
      |")
    ```
  """

  import re
  return re.sub("(^|\n)[ \t]*" + symbol, "\\1", text)
