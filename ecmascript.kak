# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](js|mjs) %{
    set buffer filetype ecmascript
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/ecmascript regions
add-highlighter shared/ecmascript/code default-region group
add-highlighter shared/ecmascript/single_string region "'"  (?<!\\)(\\\\)*' fill string
add-highlighter shared/ecmascript/double_string region '"'  (?<!\\)(\\\\)*" fill string
add-highlighter shared/ecmascript/literal       region "`"  (?<!\\)(\\\\)*` group
add-highlighter shared/ecmascript/comment_line  region //   '$'             fill comment
add-highlighter shared/ecmascript/comment       region /\*   \*/            fill comment

add-highlighter shared/ecmascript/literal/ fill string
add-highlighter shared/ecmascript/literal/ regex \$\{.*?\} 0:value

add-highlighter shared/ecmascript/code/ regex \b(Infinity|NaN|false|null|this|true|undefined)\b 0:value
add-highlighter shared/ecmascript/code/ regex "-?[0-9]*\.?[0-9]+" 0:value
add-highlighter shared/ecmascript/code/ regex \b(Array|Boolean|Date|Function|JSON|Map|Math|Number|Object|Promise|Proxy|Reflect|RegExp|Set|String|Symbol|WeakMap|WeakSet)\b 0:type
add-highlighter shared/ecmascript/code/ regex \b(Error|EvalError|InternalError|RangeError|ReferenceError|SyntaxError|TypeError|URIError)\b 0:type

# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
add-highlighter shared/ecmascript/code/ regex \b(async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|from|for|function|if|import|in|instanceof|let|new|of|return|super|switch|throw|try|typeof|var|void|while|with|yield)\b 0:keyword
add-highlighter shared/ecmascript/code/ regex => 0:keyword

# Commands
# ‾‾‾‾‾‾‾‾

def -hidden ecmascript-filter-around-selections %{
    # remove trailing white spaces
    try %{ exec -draft -itersel <a-x> s \h+$ <ret> d }
}

def -hidden ecmascript-indent-on-char %<
    eval -draft -itersel %<
        # align closer token to its opener when alone on a line
        try %/ exec -draft <a-h> <a-k> ^\h+[]}]$ <ret> m s \`|.\' <ret> 1<a-&> /
    >
>

def -hidden ecmascript-indent-on-new-line %<
    eval -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{ exec -draft k <a-x> s ^\h*\K#\h* <ret> y gh j P }
        # preserve previous line indent
        try %{ exec -draft \; K <a-&> }
        # filter previous line
        try %{ exec -draft k : ecmascript-filter-around-selections <ret> }
        # indent after lines beginning / ending with opener token
        try %_ exec -draft k <a-x> <a-k> ^\h*[[{]|[[{]$ <ret> j <a-gt> _
    >
>

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group ecmascript-highlight global WinSetOption filetype=ecmascript %{ add-highlighter window/ecmascript ref ecmascript }

hook global WinSetOption filetype=ecmascript %{
    hook window InsertEnd  .* -group ecmascript-hooks  ecmascript-filter-around-selections
    hook window InsertChar .* -group ecmascript-indent ecmascript-indent-on-char
    hook window InsertChar \n -group ecmascript-indent ecmascript-indent-on-new-line
}

hook -group ecmascript-highlight global WinSetOption filetype=(?!ecmascript).* %{ remove-highlighter window/ecmascript }

hook global WinSetOption filetype=(?!ecmascript).* %{
    remove-hooks window ecmascript-indent
    remove-hooks window ecmascript-hooks
}

# suggested hook

#hook global WinSetOption filetype=ecmascript %{
    #set window formatcmd 'prettier --stdin --semi false --single-quote --jsx-bracket-same-line --trailing-comma all'
#}

