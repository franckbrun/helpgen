#  helpgen

`helgen` can create a very simple Apple help book. It can be integrated into an automatic construction workflow. helgen has no special requirements.

This project was created for a specific need. Some parts are therefore not really well tested. But maybe Helgen can help other people...

Apologies for the current version of the documentation. It is quickly written by a man (me) who is not fluent in English. I will improve it over time...

## Other solution

- [Jekyll-apple-help](https://github.com/chuckhoupt/jekyll-apple-help) (based on Jekyll system)

## Documentation about Apple Help Book

- [Apple Documentation](https://developer.apple.com/library/archive/documentation/Carbon/Conceptual/ProvidingUserAssitAppleHelp/user_help_intro/user_assistance_intro.html#//apple_ref/doc/uid/TP30000903)

## Why ?

_Work in progress_

# Commands

`helgen` is a command line tool, written in Swift.

Dependencies are :

- swift-argument-parser
- SwiftSoup

Type `helpgen --help` to print informations.

## Create command

`helpgen create` can be used to create an empty, non functionnal, Help Book.

## Build command

`helpgen build` is used to create a valid Help Book from helpsource files.

## Index command

`helphen index` will be used, one day, to index Help Book Package.

_Work in progress_

`hiutil` should be used to index Help Book Package.

# How it works

`helpgen` parse all the `helpsource` files in the input folder and build a Help Book Package. For each langages a folder `lproj` is crated in the `Recources` folder and each `helpsource` file is "merged" whith a template (only HTML template for now) to create an HTML page.

## Sample project hirarchy

<pre>
+ Help Source Folder
   | <project_name>.helpsource
   | index.helpsource
   | other.helpsource
   | another.helpsource
   + _assets
      | image.png
      + css
         | main.css 
</pre>

By convention, the file `<project_name>.helpsource` contains important properties for the project and should not output file.

* Sample project file

```
---
project.name: Simpura

# Properties used to build Info.plist file
project.bundleDevelopmentRegion: "fr"
project.bundleIdentifier: "com.moxadventu.Simpura.help"
project.bundleName: "Simpura"
project.bundleShortVersionString: "1"
project.bundleVersion: "1"
project.bookIconPath: "../assets/SimpuraIcon.png"
project.bookAccessPath: "index.html"
project.bookIndexPath: "search.helpindex"
project.bookCSIndexPath: "search.cshelpindex"
project.bookTitle: "Simpura Help"
@fr: "Aide Simpura"

# Custom properties
project.identifier: "com.moxadventu.Simpura"

# Use default stylesheet
project.stylesheet: "../assets/css/main.css"

# Build table of content
project.toc: true

project.assetsFolder: _assets

# Do not generate output for this file 
output: false
---
```

* Sample built package hierarchy (for `en` and `fr`)

```
+- Simpura.Help
   +- Contents
	   | Info.plist
	   | PkgInfo
	   +- Resources
	      +- assets
	         | SimpuraIcon.png
	      +- en.lprog
	         | index.html
	         | other.html
	         | another.html
	      +- en.lprog
	         | index.html
	         | other.html
	         | another.html
```

## `helpsource` Files

`helpsource` files are used to generate the Help Book. Each file will be used to create an HTML help page (unless `page.output: false`).

When help shoulbe generated for multiple language only elements for the corresponding langage are used to generate the output. All localized information should be placed in a single `helpsource` file.

```
---
title: "Page Title"
@fr: "French page Title"
---

/text name=intro lang:en "This text is used in English Help"
/text name=intro lang:fr "This text is used in French Help"
/text name=intro "This text is used in All language for this page"
```

## Anatomy of a `helpsource` file

A `helpsource` file has two sections:

- a properties section were all properties are defined.
- an elements section which contains all text, image, anchors and other things that should be included in the output file.

### Sample file

<pre>
---
title: "Title"
@fr: "Titre"
---

/title lang:en "Hello"
/title lang:fr "Bonjour"

# This is a comment line
// This also
/*
This is a multiline comment
*/
</pre>
  
### Properties section

The properties section defines data used when the output page is generated. Properties can refer a project property or a page property.
A project property begins with `project.` whereas a page property starts with `page.` or nothing.

`project.name:` refer to the name of the project. `page.filename:` and `filename:` refer both of the output filename. 

Property syntax: `[project|page]<property name>:<property value>`

* Project Properties

|Property name|Value Type|Meaning|
|---|---|---|
|project.name| String |Name of the project (will be used to create the Help Book Package)|
|project.stylesheet| String |Define the default css file used by HTML generator (ie: "../assets/css/main.css")|
| project.toc | Bool | Generate table of Content (not used for now) |
| project.assetsFolder | String | Path to the assets folder. All elements in this folder will be copied in the assets folder in the Help Book Package}

* Properties used to create the Info.plist file of the Help Book

|Property name|Info.plist Key|
|---|---|
| project.bundleDevelopmentRegion | CFBundleDevelopmentRegion |
| project.bundleIdentifier | CFBundleIdentifier |
| project.bundleName | CFBundleName |
| project.bundleShortVersionString | CFBundleShortVersionString |
| project.bundleVersion| CFBundleVersion |
| project.bookIconPath | HPDBookIconPath |
| project.bookAccessPath| HPDBookAccessPath |
| project.bookIndexPath| HPDBbookIndexPath |
| project.bookCSIndexPath| HPDBookCSIndexPath |
| project.bookTitle | HPDBookTitle |

See [Apple Help Book Documentation](https://developer.apple.com/library/archive/documentation/Carbon/Conceptual/ProvidingUserAssitAppleHelp/authoring_help/authoring_help_book.html#//apple_ref/doc/uid/TP30000903-CH206-SW22) and [About Info.plist Keys and Values] (https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html)

* Custom properties

You can define custom properties:

```
---
project.my_custom_property: "hello World !"
page.my_other_property: "Custom value"
my_new_property: custom_value
---
```

* Page Properties

|Property name|Value Type|Meaning|
|---|---|---|
| output | Bool | If `false` no output is generated for this file |
| template | String | Set the template file used to generate the output |
| apple_title | String | Add meta `AppleTitle` |
| description | String | Add meta `description` |
| keywords | String | Add meta `KEYWORDS` |

### Elements section

Elements section containts all text, image video. etc that can be inserted in the destination file.

Element syntax:
```
/<element type> [<properties>] [<values>]
```
  
* List of known elements

| Element | |
|---|---|
| title | Associate an image and a text |
| text | Simple text |
| note | Simple text note |
| image | An image |
| video | A video |
| anchor| Create an anchor if the document |
| link | Link to an external URL |
| helplink | Special Help Book Link  |
| separator | A separator (like `<hr>`) |

* Values


In the felowing description, `values` means `string value` on one line or multiple lines.
Value could be :

```
This is values. Each words is recognize as a single value.
    All    theses lines  will be
  joined. The final     value will be trimmed and    all
 multiples spaces characters  will    be replaced by a single one.
```

Result:

```
This is values. Each words is recognize as a single value. All theses lines will be joined. The final value will be trimmed and all multiples spaces characters will be replaced by a single one.
```

```
"This is a value which will be recognize as a single value."
"  Several lines can follow each other.    "
" The final value is created joining all theses lines after trimming "
" (but not       here !)
```

Result:

```
This is a value which will be recognize as a single `value`. Several lines can follow each other. The final value is created joining all theses lines after trimming (but not       here !)
```

Raw string is also supported:

```
#"
this is a "raw string"
"#

##"
This is also a #raw string#
"##
```

* Specific properties of element

An element whith a `lang:` property will only be included in the when the help is generated for the corresponding language.

An element witout `lang:` property will be included in all language for the page.

#### title

Add a title section. A title contains an image and a text.

```
/title
	[lang:<langauge>]
	[image:<>]
	[size:<size of the image widthxheight>]
	[heading:<Heading of the text>]
	<values>
```

#### text

```
/text
	[name:<name>]
	[lang:<langauge>]
	[heading:<Heading of the text>]
	<values>
```

#### note

```
/note
	[name:<name>]
	[lang:<langauge>]
	[type:<type: notice, info, warning, stop, etc>]
	<values>
```

#### image

```
/image
	[name:<name>]
	[lang:<langauge>]
	src:Path to the image file (relative)
	[size:<size>]
```

#### video

```
/video
	[name:<name>]
	[lang:<langauge>]
  	src:Path to the image file (relative)
	[type:Type of the video]
	[controls:true|false]
	[autoplay:true|false]
  	[loop:true|false]
	[size:<size>]
```

#### anchor

```
/anchor
	anchor_name:<name>
	[lang:<langauge>]
```

#### link

```
/link
	[name:<name>]
	[lang:<langauge>]
	[open_app:<Bundle identifier>] | [open_prefpane:<Bundle identifier>] | [href=<URL>]
```

#### helplink

```
/helplink
	[name:<name>]
	[lang:<langauge>]
	anchor_name:<anchor name
	[book_id:Help package identifier]
```

#### separator

```
/separator
```

## HTML template

* Custom template

_Work in progress_

* Default template

This is the default HTML template used by helgen.

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>%{page.title}%</title>
  </head>
  <body>
    <div>
      %{elements:*}%
    </div>
  </body>
</html>
```

## Actions

Actions can be inserted into `values`. These are special tokens that will be replaced during the build phase of the help book.

Action syntaxt:

`@<link|open_app|open_prefpane>[parameters](text)`

| Name | Action | Parameters |
|---|---|---|
| link | Specify a link to an external URL | URL |
| (1)open_app | Open an application | Bundle Identifier of the application |
| (1)open_prefpane | Open a specific Preferences Pane | Bundle Identifier of the preference pane |

(1) Will be implemented soon

* Sample

```
"In this string value a @link[https://www.apple.com](link) to an external URN can be added of a link to an anchor in current Help Book or another one."
"You can @open_app[com.moxadventu.com](open an application) or @open_prefpane[com.apple.preferences.AppleIDPrefPane](open a prefs pane)
```

## Element formatting

### HTML output

* Heading

|Heading|Result in HTML page|
|---|---|
|"tx" or "titlex" where x=1...6| `<h1>` to `<h6>`|
| default (no heading specified) | `<p>` |

* title is inserted as 
 
```
<div id=title.name> 
	<img src=title.src> 
    <h1> title.values </h1> 
</div> 
```

* text

`/text` is inserted as

`<tag>` depend on heading value.

```
<tag>
	text.values
</tag>
```

* note

`/note` is inserted as 

```
<div class="note.type">
	note.values
</div>
```

if the `type` property is not defined, the `class` attribute is not inserted.

* link

`/link` is inserted as `<a href=<url>></a>`

* anchor

`/anchor` is inserted as `<a name="<anchor name>"></a>`

* separator

`/separator` is inserted as `<hr>`


## Localization

### Properties localization

All properties, except elemnt's properties, can be localized. To localize a property simple insert after the property value (after a white space or a line feed) :
`@<locale>:<new value>`

```
---
my_property: "Current Value"
	@fr: "Valeur francaise pour cette propriétée"
	@es: "Valor español para esta propiedad"
---
```

Localise a project property that is used in `Info.plist` file create an `InfoPlist.strings` file in the corresponding `lproj` folder.


### Elements localization

Each element can have a `lang:` property that contains a [language ID](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html).

Without `lang:` property the element will be used in all language.

```
/text lang:fr "Bonjour"
/text lang:en "Hello"
```

## Assets

The project property `project.assetsFolder` give the common assets source folder. All files and folders - except empty ones - are copied in the `assets` folder of the Help Package. This property can be localized to give specific assets source folder for a language.

## Xcode integration 

### Info.plist keys in the main application

These keys must be included in the main application's `Info.plist` file for the help manual to be found by the macOS help system.

| Name | Value |
|---|---|
| CFBundleHelpBookFolder | Name of the Help package (ie: Simpura.help) |
| CFBundleHelpBookName | Bundle identifier of the Help package (ie: com.moxadventu.Simpura.help) |

### Example of integration in Xcode (script phase)

```
set -e 

LANGS="en fr"
SOURCEHELPFOLDER="$SRCROOT/Help/Source"
OUTPUTHELPFOLDER="$CONFIGURATION_BUILD_DIR"

HELPGEN="$CONFIGURATION_BUILD_DIR/helpgen"

echo "Build Apple Help Book..."
"$HELPGEN" -v build --overwrite -p Simpura -l "$LANGS" -i "$SOURCEHELPFOLDER" -o "$OUTPUTHELPFOLDER"

# Index help file

ROOTHELP="$CONFIGURATION_BUILD_DIR/Simpura.help/Contents/Resources"

for LANG in $LANGS
do
    echo "indexing ${LANG} ..."
    hiutil -vv -I lsm -C -a -l "${LANG}" -f "$ROOTHELP/$LANG.lproj/search.helpindex" "$ROOTHELP/$LANG.lproj/"
    hiutil -vv -I corespotlight -C -a -l "${LANG}" -f "$ROOTHELP/$LANG.lproj/search.cshelpindex" "$ROOTHELP/$LANG.lproj/"
done

# Copy in bundle
echo "Copying Help in Bundle..."

cp -R "${CONFIGURATION_BUILD_DIR}/Simpura.help" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" 


```
