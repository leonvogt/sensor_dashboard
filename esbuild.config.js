const watch = process.argv.includes('--watch')
const railsEnv = process.env.RAILS_ENV || 'development'
const errorFilePath = `esbuild_error_${railsEnv}.txt`

const path = require('path')
const fs = require('fs')

function handleError(error) {
  if (error) fs.writeFileSync(errorFilePath, error.toString())
  else if (fs.existsSync(errorFilePath)) fs.truncate(errorFilePath, 0, () => {})
}

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: watch && { onRebuild: handleError },
  // custom plugins will be inserted is this array
  plugins: [],
}).catch(() => process.exit(1));
