# kakoune-ecmascript

Opinionated alternative to [kakoune](http://kakoune.org) built-in JavaScript plugin.

## Install

Add `ecmascript.kak` to your autoload dir: `~/.config/kak/autoload/`.
It is a substitute to [`javascript.kak`](https://github.com/mawww/kakoune/blob/master/rc/base/javascript.kak) ; both should not be loaded simultaneously.

## Differences with original

This script is almost a direct *fork* of the aforementioned `javascript.kak`.
The main differences concern the highlighting:

- do not assume a specific environment (browser, Node.js). So `window`, `document`, `parent`… are out.
- add more special values like `NaN`, `Infinity`…
- add more constructors like `Promise`, `Set`, `WeakMap`…
- add error constructors like `Error`, `TypeError`…
- add highlighting for `=>` (arrow functions)
- remove highlighting for regexp. It was buggy, especially with closing tags in *JSX*.

No special effort will be made to handle indentation rules, this job is better done by [Prettier](https://github.com/prettier/prettier):

```
hook global WinSetOption filetype=ecmascript %{
    set window formatcmd 'prettier --stdin --semi false --single-quote --jsx-bracket-same-line --trailing-comma all'
}
```

## See also

- [eslint-formatter-kakoune](https://github.com/Delapouite/eslint-formatter-kakoune)
- [kakoune-flow](https://github.com/Delapouite/kakoune-flow)
- [kakoune-typescript](https://github.com/atomrc/kakoune-typescript)

## Licence

MIT

