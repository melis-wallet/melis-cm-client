const YAML = require('yamljs')
var glob = require('glob')
//const fs = require('fs')
const fs = require('fs-extra')
const path = require('path')

const writeOptions = {encoding: 'utf-8'}
var sourceFolder = "i18n/"
var emberI18RootFolder = "app/locales/"
var baseFileName = 'melis'
var extension = '.yml'
var outfile = 'translations.js'
var cmBaseFolder = '../ChainMaster'

function pushServerMessages() {
  if (!fs.existsSync(cmBaseFolder) || !fs.statSync(cmBaseFolder).isDirectory()) {
    console.log(cmBaseFolder + " not found: skipping server messages")
    return
  }
  var targetFolder = cmBaseFolder + "/src/main/resources/"
  if (!fs.existsSync(targetFolder) || !fs.statSync(targetFolder).isDirectory()) {
    console.log(targetFolder + " is not accessible !? Skipping server messages")
    return
  }
  var files = glob.sync(sourceFolder + 'messages*.properties')
  console.log("Server messages files:", files)

  files.forEach(f => {
    var targetFile = targetFolder + path.basename(f)
    if (fs.existsSync(targetFile)) {
      fs.chmodSync(targetFile, 0666)
      fs.unlinkSync(targetFile)
    }
    //fs.createReadStream(f).pipe(fs.createWriteStream(targetFile));
    fs.copySync(f, targetFile)
    fs.chmodSync(targetFile, 0444)
  })
}

if (!fs.statSync(sourceFolder).isDirectory()) {
  console.log("Can't find source folder: " + sourceFolder)
  process.exit(-1)
}
if (!fs.statSync(emberI18RootFolder).isDirectory()) {
  console.log("Can't find target folder: " + emberI18RootFolder)
  process.exit(-1)
}

var files = glob.sync(sourceFolder + baseFileName + '-*' + extension)
console.log("Input files:", files)

function writeJsonFromYaml(yaml, lang) {
  var langDir = emberI18RootFolder + lang
  if (!fs.existsSync(langDir))
    fs.mkdirSync(langDir)
  var langFile = langDir + "/" + outfile
  fs.writeFileSync(langFile, "export default " + JSON.stringify(yaml, null, 2) + ";\n", writeOptions)
  console.log("Created " + langFile)
  //console.log("export default " + JSON.stringify(yaml[locale], null, 2) + "\n")
}

function patchMissingKeys(source, dest, path) {
  for (let attr in source) {
    let currPath = [...path, attr]
    let x = source[attr]
    if (dest[attr] === undefined) {
      console.log('Missing key ' + currPath)
      dest[attr] = x
    } else if (typeof x === 'object')
      patchMissingKeys(x, dest[attr], currPath)
  }
}

let engYaml
let yamls = {}

files.forEach(f => {
  var basename = path.basename(f, extension)
  var lang = basename.substring(baseFileName.length + 1)
  fs.access(f, fs.constants.R_OK, (err) => {
    if (err) {
      console.log("Unable to access source file: " + f, err)
      process.exit(-1)
    }
  })
  try {
    var yaml = YAML.load(f)
    if (!yaml || !yaml[lang]) {
      console.log("Unable to find top key '" + lang + "' in source file: " + f)
      process.exit(-2)
    }
    if (lang === 'en')
      engYaml = yaml[lang]
    else
      yamls[lang] = yaml[lang]
  } catch (err) {
    console.log("Parsing error while loading " + f + ":\n", err)
    process.exit(-3)
  }
})

writeJsonFromYaml(engYaml, 'en')
Object.keys(yamls).forEach(lang => {
  let translation = yamls[lang]
  patchMissingKeys(engYaml, translation, [])
  writeJsonFromYaml(translation, lang)
})

pushServerMessages()
