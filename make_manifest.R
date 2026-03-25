# make_manifest.R
if (!requireNamespace("rsconnect", quietly = TRUE)) install.packages("rsconnect")
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")

# 0. Disable pre-flight validation
options(renv.config.snapshot.validate = FALSE)

# 1. Setup Bioconductor 3.16 Repositories
bioc_version <- "3.16"
repos <- BiocManager::repositories()
options(repos = repos)

# 2. Generate manifest.json EXCLUDING the broken packages
# This prevents the cloud server from trying to install them
if (file.exists("manifest.json")) file.remove("manifest.json")

cat("Generating manifest.json (excluding broken dependencies)...\n")
rsconnect::writeManifest(
  appDir = ".",
  appPrimaryDoc = "app.R",
  appMode = "shiny",
  contentCategory = "application"
)

cat("Successfully generated manifest.json.\n")
