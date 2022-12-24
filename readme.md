# Lua Obfuscator REST API Example

[LuaObfuscator.com](https://luaobfuscator.com) is a neat online Lua obfuscation platform that comes with some basic yet powerful obfuscation techniques. They do offer a REST API which is what this example project is all about. This repository demonstrates how to integrate the REST API into a GitHub repository using GitHub Actions.

# 👀 Demo

To automate the obfuscation of the `src/loader.lua` file using the `config/loader.json` I used a few basic Unix utils in a bash script. The results can be found on [this GitHub Actions page](https://github.com/ferib/LuaExample/actions).

# 📝 Setup
To get started, you will need to create a new workflow file and populate it as follows:

Give it a name and define when it should trigger.

```yml
name: Publish Lua (obfuscated)

on:
  push:
    branches: [ master, actions ]
```

Next, add a job and specify a target platform. For our use case, we will stick with just ubuntu-latest.

```yml
    jobs:
    build:

        runs-on: ubuntu-latest
```

Next, we will need to add a few steps, starting with `actions/checkout@v3` to access our git files

```yml
    steps:
      - uses: actions/checkout@v3
```

To install our dependencies, we will be using `curl` for the HTTP requests and `jq` to handle the JSON formatting.

```yml
      # make sure its installed?
      - name: Install dependencies
        run: |
            sudo apt-get install jq curl -y
```

Finally, we have come to the juicy part where we perform the REST API calls and process the response. The below snippet will grab the `src/loader.lua` file and applies the `config/loader.json` as its configuration.

```yml
      # Obfuscate src/loader.lua > public/loader.lua
      - name: LuaObfuscator REST API
        shell: bash {0}
        run: |
            mkdir public
            curl -X POST https://luaobfuscator.com/api/obfuscator/newscript \
            -H "Content-type: application/json" \
            -H "apikey: test" \
            --data-binary "@src/loader.lua" \
            | curl -X POST https://luaobfuscator.com/api/obfuscator/obfuscate \
            -H "Content-type: application/json" \
            -H "apikey: test" \
            --data "@config/loader.json" \
            -H "sessionId: $(grep -o -P '(?<="sessionId":").*(?="})')" \
            | jq -r ".code" \
            > public/loader.lua
```

Last but not least, we need to create an artifact of our files as we can download them once our container is destroyed. Do so using `actions/upload-artifact@v1`.

```yml
      # publish public/loader.lua
      - name: Create artifact
        uses: actions/upload-artifact@v1
        with:
          name: release_protected
          path: public/
```

# 🧪 Example
The complete version of the above script can be found at [.github/workflows/luaobfuscator.yml](.github/workflows/luaobfuscator.yml)
