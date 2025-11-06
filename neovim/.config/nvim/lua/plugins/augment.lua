local isWorkLaptop = require("config.utils").isWorkLaptop

return {
  {
    'augmentcode/augment.vim',
    enabled = isWorkLaptop(),
  }
}
