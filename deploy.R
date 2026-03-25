# deploy.R
if (!requireNamespace("rsconnect", quietly = TRUE)) install.packages("rsconnect")
library(rsconnect)

# 1. Clear Local Cache (Nuclear Fix)
if (dir.exists("rsconnect")) {
  unlink("rsconnect", recursive = TRUE)
}

# 2. Prepare deployment
cat("Starting final deployment to Posit Connect Cloud (ShinyHood-v5)...\n")
new_app_name <- "ShinyHood-v5"

# Regenerate manifest
source("make_manifest.R")

# Hide renv.lock
if (file.exists("renv.lock")) {
  file.rename("renv.lock", "renv.lock.bak")
  on.exit(if (file.exists("renv.lock.bak")) file.rename("renv.lock.bak", "renv.lock"), add = TRUE)
}

# Define files
deploy_files <- c("app.R", "data/courses.csv", "manifest.json", "_extensions")

# 3. Deploy
options(rsconnect.http.verbose = TRUE)

rsconnect::deployApp(
  appDir = ".",
  appPrimaryDoc = "app.R",
  server = "connect.posit.cloud",
  appName = new_app_name,
  appFiles = deploy_files,
  forceUpdate = TRUE
)

cat("\nDeployment complete! You can view your app at the URL provided above.\n")
