# muwu - Markup Writeup

compile markdown files from a human-readable outline

_"Maybe WYSIWYG is not WYW."_


## About Muwu

Muwu was created in response to dissatisfaction with commercial word processors, particularly the poor support for exporting to HTML.

  - Muwu starts with the outline.
    - Easy to rearrange your project.
    - Develop your project using smaller, manageable files.
    - Organize your project to your needs.
    - Use your favorite text editor!
  - Muwu can make a table of contents.
    - Hyperlink your document.
    - Automatic section numbering.
  - Muwu reads Markdown.
    - Simple syntax.
    - Focus on the text now, save the formatting for later!
  - Muwu reads Haml.
    - Just in case Markdown isn't enough.
  - Muwu reads YAML.
    - Simple syntax for the project outline, project metadata, and project options.
  - Muwu writes HTML5 and CSS3.
    - Flexible rendering for screen and print media.
    - Does not use inline `style=` attributes.

Maybe you don't know the page size for which a work will be destined. Maybe there is no page. Maybe a project is still deep in development, and it's too soon to be thinking about fonts, formatting, margins, spacing, and styles. Maybe *what-you-see-is-what-you-get* is not *what you want*.


## Installing Muwu

To install Muwu as a Ruby Gem, use the command:

~~~
gem install muwu --version '4.0.0.beta'
~~~


## License and Disclaimer

  - Muwu is licensed for use under the GNU GPLv3.
  - Muwu is provided as-is, with *absolutely no guarantees or warranties*.


## Command Line

`muwu`
: Show the version number and a summary of commands.

`muwu compile`
: Compile all parts of the project.

`muwu compile css`
: Compile only the stylesheet for the project.

`muwu compile html`
: Compile all HTML files.

`muwu compile html [index]`
: Compile only the HTML file with the given index number.

`muwu compile js`
: Compile any Javascript files.

`muwu concat`
: Concatenate all source files, including section number and outline heading.

`muwu help`
: Show the version number and a summary of commands.

`muwu help [command]`
: Show more detailed help for the given command.

`muwu inspect`
: Display the project options, the compiler manifest, index numbers of HTML files, and any exceptions.

`muwu new`
: Create a new project as a subdirectory within the current working directory.

`muwu publish`
: Publish the compiled project to a remote location. _(requires rsync)_

`muwu reset compiled`
: Erase the contents of the `compiled` folder

`muwu reset css`
: Return the initial base CSS files to their original contents.

`muwu sync pull [options]`
: Synchronize the project from a remote location. _(requires rsync)_

`muwu sync push [options]`
: Synchronize the project to a remote location. _(requires rsync)_

`muwu view`
: View the compiled project in a web browser. _(shortcut for `open compiled/[index.html]`)_

## User Guide

<https://didntfollowtheinstructions.com/muwu> contains detailed instructions, and is an example of a compiled muwu project.
