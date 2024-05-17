require("luasnip.session.snippet_collection").clear_snippets("go")

local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

ls.add_snippets("go", {
  s("ie", fmta("if err != nil {\n\t<>\n}<>", { i(1), i(0) })),
  s("wr", fmt("w http.ResponseWriter, r *http.Request", {})),
})
