### Install
```javascript
npm install grunt-foreman --save-dev
```

### Usage
Use as such:
```javascript
grunt.loadNpmTasks("grunt-foreman");

grunt.registerTask("serve", ["sass", "coffee", "foreman"]);
```

No need for an entry in `grunt.initConfig({})`.

Enjoy!
