# require
require is a global function,
it use a cache system so two inport in your inport tree wont duplicate code.

there is a few rules :
- (WARN) know that it will look for a "lua" directory as a root directory.
   the lua directory is a logic root require will always scan from lua/
- require use "." instead of "/"
- dont add the file extension

for example
```lua
require("path.to.file")
```
will require the file lua/path/to/file.lua


# require (with table)
you can to create a table and attach function to it
then you will have to return the table, it will allow you to import
table instead of direct function

example :
create table
```lua
-- plugins/myplugin.lua
local TableRed = {}

function M.say_hi()
  print("Hi from myplugin!")
end

return TableRed
```
import table
```lua
local importedTable = require("tableRedFile")
importedTable.say_hi()
```

