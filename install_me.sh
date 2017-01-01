
function main {
git clone https://github.com/Sudokamikaze/rom-buildscripts.git
rm -rf .git
rm install_me.sh
}

function ascii {
  echo -e "
          ------               _____
         /      \ ___\     ___/    ___
      --/-  ___  /    \/  /  /    /
     /     /           \__     //_
    /                     \   / ___     |
    |           ___       \/+--/        /
     \__           \       \           /
        \__                 |          /
       \     /____      /  /       |   /
        _____/         ___       \/  /
             \__      /      /    |    |
           /    \____/   \       /   //
       // / / // / /\    /-_-/\//-__-
        /  /  // /   \__// / / /  //
       //   / /   //   /  // / // /
        /// // / /   /  //  / //
  "
}


echo "Installing scripts"
ascii
main
