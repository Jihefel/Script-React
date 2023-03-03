# !/bin/bash

### Creation Structure pour React + SASS/SCSS/CSS + Tailwind + Bootstrap + Font Awesome ####

# Création App React
echo "Quel est le nom de votre app React ?"
read appName
appName="$(echo "$appName" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"

# SASS/SCSS/CSS
echo "Besoin de SASS (a), SCSS (s) ou CSS (c) ?"
read styleType
while [[ $styleType != "a" && $styleType != "s" && $styleType != "c" ]]; do
  echo "Entrez 'a' pour SASS ou 's' pour SCSS ou 'c' pour CSS:"
  read styleType
done

# Organisé comment ?
structureSass=1
if [[ $styleType == "a" || $styleType == "s" ]]; then
  echo "Comment organiser le SASS/SCSS ?"
  echo "(1) : Fichiers style dans chaque Component; (2) : Structure src/sass/modules, (3) : Pattern SASS 7-1 /!\ Avancé"
  read structureSass
  while [[ $structureSass != 1 && $structureSass != 2 && $structureSass != 3 ]]; do
    echo "Tapez '1' pour les fichiers CSS/SASS dans chaque Component ou '2' pour la structure SASS dans src avec le dossier 'modules' ou '3' pour le pattern SASS avancé '7-1' :"
    read structureSass
  done
fi

# Nom du 1er component
echo "Nom de votre 1er component ?"
read compName
while [[ -z $(echo $compName | xargs) ]]; do
  echo "Entrez un nom de component valide:"
  read compName
done
compName="$(echo ${compName:0:1} | tr '[:lower:]' '[:upper:]')$(echo ${compName:1} | tr '[:upper:]' '[:lower:]')"
compName=$(echo $compName | xargs)

compName_lowercase="$(echo "$compName" | tr '[:upper:]' '[:lower:]')"
compName_sass="_${compName_lowercase}"

# # Font Awesome
# echo "Besoin de Font Awesome ? (y)"
# read fontAwesome

# React Icons
echo "Besoin de React Icons ? (y)"
read reactIcons

# Bootstrap
echo "Besoin de Bootstrap ? (y)"
read bootstrap
# Style Bootstrap
if [[ $bootstrap == "y" ]]; then
  echo "Bootstrap normal (1) ou React Bootstrap (2) ?"
  read styleBootstrap
  while [[ $styleBootstrap != 1 && $styleBootstrap != 2 ]]; do
    echo "Tapez '1' pour utiliser le Bootstrap normal ou '2' pour utiliser React Bootstrap"
    read styleBootstrap
  done
fi

# Tailwind
echo "Besoin de TailWind ? (y)"
read tailwind

# React Router
echo "Besoin de React Router ? (y)"
read reactRouter

# Axios
echo "Besoin de Axios ? (y)"
read axios

# create-react-app
npx create-react-app $appName

# Déplacement dans le dossier de l'app
cd $appName

# Remise à zéro du dossier src
rm -rf ./src/*

# Ajout des fichiers indispensables
mkdir -p ./src/components/

# Ajouter des fichiers App et index.sass
function touchSass {
  touch $1{_app.$2,_index.$2}
  touch ./src/components/$compName/$compName_sass.$2
}

# Texte dans App1.jsx
function textApp1 {
  cat <<EOF
import './$2.$1';
import $compName from './components/$compName/$compName';

function App() {
  return (
    <div className='App'>
      <$compName />
    </div>
  );
}

export default App;
EOF
}

# Texte dans App3.jsx
function textApp2 {
  cat <<EOF
import $compName from './components/$compName';

function App() {
  return (
    <div className='App'>
      <$compName />
    </div>
  );
}

export default App;
EOF
}

# Texte dans index.jsx
function textIndex1 {
  cat <<EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import '$1.$2'
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF
}

#Texte dans component1
function textComp1 {
  cat <<EOF
import './$1.$2'

function $compName() {

  return(
    <div className="$compName">
      
    </div>
  )

}

export default $compName
EOF
}

#Texte dans component1
function textComp2 {
  cat <<EOF


  
function $compName() {

  return(
    <div className="$compName">
      
    </div>
  )

}

export default $compName
EOF
}

# Fonction d'écriture des imports dans app.sass
function importSass {
  cat <<EOF
// Fonts
@import ./_fonts
// Variables
@import ./_variables
EOF
}

# Fonction d'écriture des imports dans app.scss
function importScss {
  cat <<EOF
// Fonts
@import './_fonts';
// Variables
@import './_variables';
EOF
}

# Fonction d'écriture des imports dans app.sass Pattern 7-1
function importSass7 {
  cat <<EOF
// Fonts
@import ./base/_fonts
// Variables
@import ./utilities/_variables
EOF
}

# Fonction d'écriture des imports dans app.scss Pattern 7-1
function importScss7 {
  cat <<EOF
// Fonts
@import './base/_fonts';
// Variables
@import './utilities/_variables';
EOF
}

# Ajout des imports pour ajout/modification de variables Bootstrap dans _variables.sass
function variablesSass {
  cat <<EOF
// COLORS Sass
\$lightgrey: #dddddd


EOF
}

function variablesScss {
  cat <<EOF
// COLORS Sass
\$lightgrey: #dddddd;


EOF
}

if [[ $structureSass == "1" ]]; then
  mkdir -p ./src/components/$compName
  touch ./src/{App.jsx,index.jsx} ./src/components/$compName/$compName.jsx
  case $styleType in
  a)
    npm i sass --save-dev
    touchSass ./src/ sass
    textApp1 sass _app >>./src/App.jsx
    textIndex1 ./_index sass >>./src/index.jsx
    textComp1 $compName_sass sass >>./src/components/$compName/$compName.jsx
    ;;
  s)
    npm i sass --save-dev
    touchSass ./src/ scss
    textApp1 scss _app >>./src/App.jsx
    textIndex1 ./_index scss >>./src/index.jsx
    textComp1 $compName_sass scss >>./src/components/$compName/$compName.jsx
    ;;
  c)
    touch ./src/{App.css,index.css} ./src/components/$compName/$compName_lowercase.css
    textApp1 css App >>./src/App.jsx
    textIndex1 ./index css >>./src/index.jsx
    textComp1 $compName_lowercase css >>./src/components/$compName/$compName.jsx
    ;;
  *)
    echo "Erreur dans le type de fichier de style désiré"
    ;;
  esac
elif [[ $structureSass == "2" ]]; then
  mkdir -p ./src/sass/modules/
  mkdir -p ./src/pages/
  touch ./src/{App.jsx,index.jsx} ./src/components/$compName.jsx
  npm i sass --save-dev
  case $styleType in
  a)
    touch ./src/sass/modules/_imports.sass ./src/sass/_fonts.sass ./src/sass/main.sass ./src/sass/_variables.sass ./src/sass/modules/$compName_sass.sass
    textApp2 >>./src/App.jsx
    textIndex1 ./sass/main sass >>./src/index.jsx
    textComp2 >>./src/components/$compName.jsx
    importSass >>./src/sass/main.sass
    variablesSass >>./src/sass/_variables.sass
    echo -e "// Utilisez ce fichier pour les imports de vos modules\n@import ./${compName_sass}" >>./src/sass/modules/_imports.sass
    ;;
  s)
    touch ./src/sass/modules/_imports.scss ./src/sass/_fonts.scss ./src/sass/main.scss ./src/sass/_variables.scss ./src/sass/modules/$compName_sass.scss
    textApp2 >>./src/App.jsx
    textIndex1 ./sass/main scss >>./src/index.jsx
    textComp2 >>./src/components/$compName.jsx
    importScss >>./src/sass/main.scss
    variablesScss >>./src/sass/_variables.scss
    echo -e "// Utilisez ce fichier pour les imports de vos modules\n@import './${compName_sass}';" >>./src/sass/modules/_imports.scss

    ;;
  *)
    echo "Erreur dans la création des fichiers modules pour SASS"
    ;;
  esac
elif [[ $structureSass == "3" ]]; then
  mkdir -p ./{src/sass/{base/,components/,pages/,themes/,utilities/,vendors/},src/{models/,pages/,api/}}
  touch ./src/{App.jsx,index.jsx} ./src/components/$compName.jsx ./src/api/api.js
  npm i sass --save-dev
  case $styleType in
  a)
    touch ./src/sass/{base/{_imports.sass,_body.sass,_fonts.sass},components/$compName_sass.sass,utilities/{_variables.sass,_mixins.sass}}
    textApp2 >>./src/App.jsx
    textIndex1 ./sass/main sass >>./src/index.jsx
    textComp2 >>./src/components/$compName.jsx
    importSass7 >>./src/sass/main.sass
    variablesSass >>./src/sass/utilities/_variables.sass
    echo -e "// Utilisez ce fichier pour les imports globaux\n@import ../components/${compName_sass}" >>./src/sass/base/_imports.sass
    ;;
  s)
    touch ./src/sass/{base/{_imports.scss,_body.scss,_fonts.scss},components/$compName_sass.scss,utilities/{_variables.scss,_mixins.scss}}
    textApp2 >>./src/App.jsx
    textIndex1 ./sass/main scss >>./src/index.jsx
    textComp2 >>./src/components/$compName.jsx
    importScss7 >>./src/sass/main.scss
    variablesScss >>./src/sass/utilities/_variables.scss
    echo -e "// Utilisez ce fichier pour les imports globaux\n@import '../components/${compName_sass}';" >>./src/sass/base/_imports.scss
    ;;
  *)
    echo "Erreur dans la création des fichiers modules pour SASS 7-1"
    ;;
  esac
fi

# Suppression des fichiers de /public
rm -rf public/*

# Creation de l'index.html dans public
touch ./public/index.html
mkdir -p ./public/assets/{images/,fonts/,data/,audios/,videos/}

#Texte dans l'index
function textHTML {
  cat <<EOF
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$appName</title>
</head>

<body>
    <div id="root"></div>
</body>

</html>
EOF
}
textHTML >>./public/index.html

# # Font Awesome
# if [[ $fontAwesome == "y" ]]; then
#   npm i -S @fortawesome/fontawesome-svg-core @fortawesome/free-solid-svg-icons @fortawesome/free-regular-svg-icons @fortawesome/free-brands-svg-icons @fortawesome/react-fontawesome@latest
# fi

# React Icons
if [[ $reactIcons == "y" ]]; then
  npm install react-icons --save
fi

# BootStrap
if [[ $bootstrap == "y" ]]; then
  if [[ $styleBootstrap == "1" ]]; then
    npm i bootstrap
    sed -i "13i\<\!-- Script JS Bootstrap -->\n<script src='../node_modules/bootstrap/dist/js/bootstrap.bundle.js'></script>" ./public/index.html
  elif [[ $styleBootstrap == "2" ]]; then
    npm install react-bootstrap bootstrap
  fi

  if [[ $structureSass == "1" ]]; then

    case $styleType in
    a)
      echo "@import ~bootstrap/scss/bootstrap" >>./src/_app.sass
      ;;
    s)
      echo "@import '~bootstrap/scss/bootstrap';" >>./src/_app.scss
      ;;
    c)
      sed -i "3i\import 'bootstrap/dist/css/bootstrap.min.css';" ./src/index.jsx
      ;;
    *)
      echo "Erreur dans le type de fichier de style désiré"
      ;;
    esac

  elif
    [[ $structureSass == "2" ]]
  then

    case $styleType in
    a)
      echo -e "@import ~bootstrap/scss/_functions.scss\n@import ~bootstrap/scss/_variables.scss\n\n// COLORS Sass\n\$lightgrey: #dddddd\n\n// COLORS Bootstrap\n\$custom-colors: ('lightgrey': #dddddd)\n\n// Merge the maps\n\$theme-colors: map-merge(\$theme-colors, \$custom-colors)" >./src/sass/_variables.sass
      echo -e "// Bootstrap\n@import ~bootstrap/scss/bootstrap" >>./src/sass/main.sass
      ;;
    s)
      echo -e "@import '~bootstrap/scss/_functions.scss';\n@import '~bootstrap/scss/_variables.scss';\n\n// COLORS Sass\n\$lightgrey: #dddddd;\n\n// COLORS Bootstrap\n\$custom-colors: ('lightgrey': #dddddd);\n\n// Merge the maps\n\$theme-colors: map-merge(\$theme-colors, \$custom-colors);" >./src/sass/_variables.scss
      echo -e "// Bootstrap\n@import '~bootstrap/scss/bootstrap';" >>./src/sass/main.scss
      ;;
    *)
      echo "Erreur Bootstrap SASS"
      ;;
    esac
  elif [[ $structureSass == "3" ]]; then

    case $styleType in
    a)
      touch ./src/sass/vendors/_bootstrap.sass

      echo -e "@import ~bootstrap/scss/bootstrap\n" >>./src/sass/vendors/_bootstrap.sass

      echo -e "// Bootstrap\n@import ./vendors/_bootstrap" >>./src/sass/main.sass

      echo -e "@import ~bootstrap/scss/_functions.scss\n@import ~bootstrap/scss/_variables.scss\n\n// COLORS Sass\n\$lightgrey: #dddddd\n\n// COLORS Bootstrap\n\$custom-colors: ('lightgrey': #dddddd)\n\n// Merge the maps\n\$theme-colors: map-merge(\$theme-colors, \$custom-colors)" >./src/sass/utilities/_variables.sass

      ;;
    s)
      touch ./src/sass/vendors/_bootstrap.scss

      echo -e "@import '~bootstrap/scss/bootstrap';\n" >>./src/sass/vendors/_bootstrap.scss

      echo -e "// Bootstrap\n@import './vendors/_bootstrap';" >>./src/sass/main.scss

      echo -e "@import '~bootstrap/scss/_functions.scss';\n@import '~bootstrap/scss/_variables.scss';\n\n// COLORS Sass\n\$lightgrey: #dddddd;\n\n// COLORS Bootstrap\n\$custom-colors: ('lightgrey': #dddddd);\n\n// Merge the maps\n\$theme-colors: map-merge(\$theme-colors, \$custom-colors);" >./src/sass/utilities/_variables.scss

      ;;
    *)
      echo "Erreur Bootstrap SCSS"
      ;;
    esac
  fi
fi

# TailWind
if [[ $tailwind == "y" ]]; then
  npm install -D tailwindcss
  npx tailwindcss init

  # Modification du JSON de Tailwind
  function tailwindJs {
    cat <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF
  }
  tailwindJs >./tailwind.config.js

  # Si bootstrap et tailwind
  if [[ $tailwind == "y" && $bootstrap == "y" ]]; then
    function tailwindJsWithBootstrap {
      cat <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  prefix: 'tw-',
  theme: {
    extend: {},
  },
  corePlugins: {
    preflight: true,
  },
  plugins: [],
};
EOF
    }
    tailwindJsWithBootstrap >./tailwind.config.js
  fi

  if [[ $structureSass == "1" ]]; then

    case $styleType in
    a)
      echo -e "// Tailwind\n@tailwind base\n@tailwind components\n@tailwind utilities" >>./src/_index.sass
      ;;

    s)
      echo -e "// Tailwind\n@tailwind base;\n@tailwind components;\n@tailwind utilities;" >>./src/_index.scss
      ;;

    c)
      echo -e "/* Tailwind */\n@tailwind base;\n@tailwind components;\n@tailwind utilities;" >>./src/index.css
      ;;

    *)
      echo "Erreur tw"
      ;;
    esac
  elif [[ $structureSass == "2" ]]; then

    case $styleType in
    a)
      echo -e "// Tailwind\n@tailwind base\n@tailwind components\n@tailwind utilities" >>./src/sass/main.sass
      ;;

    s)
      echo -e "// Tailwind\n@tailwind base;\n@tailwind components;\n@tailwind utilities;" >>./src/sass/main.scss
      ;;

    *)
      echo "Erreur tw"
      ;;
    esac
  elif [[ $structureSass == "3" ]]; then

    case $styleType in
    a)
      echo -e "// Tailwind\n@tailwind base\n@tailwind components\n@tailwind utilities" >>./src/sass/main.sass
      ;;

    s)
      echo -e "// Tailwind\n@tailwind base;\n@tailwind components;\n@tailwind utilities;" >>./src/sass/main.scss
      ;;

    *)
      echo "Erreur tw"
      ;;
    esac
  fi
fi

# Fin
if [[ $structureSass == "2" ]]; then

  case $styleType in
  a)
    echo -e "// Imports\n@import ./modules/_imports" >>./src/sass/main.sass
    ;;

  s)
    echo -e "// Imports\n@import './modules/_imports';" >>./src/sass/main.scss
    ;;

  *)
    echo "Erreur "
    ;;
  esac
elif [[ $structureSass == "3" ]]; then

  case $styleType in
  a)
    echo -e "// Imports\n@import ./base/_imports" >>./src/sass/main.sass
    ;;

  s)
    echo -e "// Imports\n@import './base/_imports';" >>./src/sass/main.scss
    ;;

  *)
    echo "Erreur"
    ;;
  esac

fi

if [[ $reactRouter == "y" ]]; then
  npm i react-router-dom
fi

if [[ $axios == "y" ]]; then
  npm i axios
fi

# Lancement de l'app
echo "LANCEMENT DE L'APP REACT. BON TRAVAIL !"
npm start
