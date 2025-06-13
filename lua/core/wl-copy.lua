vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
        ['+'] = 'wl-copy --type text/plain',
        ['*'] = 'wl-copy --type text/plain',
    },
    paste = {
        ['+'] = 'wl-paste --no-newline',
        ['*'] = 'wl-paste --no-newline',
    },
    cache_enabled = 1,
}

