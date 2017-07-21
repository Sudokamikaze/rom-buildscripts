
function main {
git clone https://github.com/Sudokamikaze/rom-buildscripts.git
mv rom-buildscripts/*.sh ./
rm install_me.sh
rm -rf rom-buildscripts
}

function ifinstalled {
if [ -f "build_rom.sh" ]; then
  echo "Already installed, scripts will updated"
else echo "Installing scripts..."
fi
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

clear
ifinstalled
ascii
main
