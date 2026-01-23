-- Termux only 
vim.env.PATH = table.concat({
    "/data/data/com.termux/files/usr/bin", vim.env.HOME .. "/.cargo/bin",
    vim.env.HOME .. "/.npm-global/bin",
    vim.env.PATH,
}, ":")
