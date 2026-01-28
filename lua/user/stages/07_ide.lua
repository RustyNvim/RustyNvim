-- In user/stages/07_ideB.lua
local defer = function(mod, ms) 
  vim.defer_fn(function() require(mod) end, ms) 
end

-- ide 
require('user.config.ide.ide.module_require.autosave')
defer('user.config.ide.ide.module_require.run', 200)
defer('user.config.ide.ide.local_module.dustTerm_module', 200)
defer('user.config.ide.ide.treesitter', 50)
defer('user.config.ide.ide.showkey', 200)
defer('user.config.ide.ide.whkey', 100)
defer('user.config.ide.ide.yanky', 100)
defer('user.config.ide.ide.undotree', 200)
defer('user.config.ide.ide.surround', 200)
defer('user.config.ide.ide.sessions', 200)


-- file
defer('user.config.ide.file.fzf', 100)    
defer('user.config.ide.file.leap', 100)   
defer('user.config.ide.file.fold', 100)   
defer('user.config.ide.file.oil', 150)    

require('user.config.ide.ide.comments')
