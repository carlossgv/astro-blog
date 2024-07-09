---
id: sed
aliases:
  - Sed
tags: []
author: Carlos G.
description: ""
featured: false
modDatetime: 2024-07-09T07:15:30.000Z
pubDatetime: 2024-07-09T07:15:30.000Z
title: Sed
---


---
id: sed
aliases:
  - Sed
tags: []
author: Carlos G.
description: ""
featured: false
modDatetime: 2024-07-09T07:07:20.000Z
pubDatetime: 2024-07-09T07:07:20.000Z
title: Sed
---

# Sed

## Use same command in MacOS and Linux

### Install GNU sed in MacOS

```bash
brew install gnu-sed
```

This will install GNU sed as `gsed`. To use it, you can create an alias in your `.bashrc` or `.zshrc` file:

```bash
alias sed='gsed'
```

## Replace a string in a file

> -i flag writes the changes to the file

```bash
sed -i '' 's/old/new/g' file.txt # Macos
sed -i 's/old/new/g' file.txt # Linux
```

> The delimiter can be any character, not just /

```bash
sed -i '' 's|old|new|g' file.txt # Macos
sed -i 's|old|new|g' file.txt # Linux
```
