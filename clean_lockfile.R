library(jsonlite)

# 1. Load the existing lockfile
lock_path <- "renv.lock"
if (!file.exists(lock_path)) {
  stop("renv.lock not found in the current directory.")
}

lock <- fromJSON(lock_path, simplifyVector = FALSE)

# 2. Identify and fix Bioconductor repositories
# Even if they aren't explicitly used, the scanner can fail if it finds 
# versioned Bioconductor strings in the header or package suggests.
bioc_version <- "3.16" # Matching R 4.2.3
bioc_repos <- list(
  list(Name = "BioCsoft", URL = paste0("https://bioconductor.org/packages/", bioc_version, "/bioc")),
  list(Name = "BioCann",  URL = paste0("https://bioconductor.org/packages/", bioc_version, "/data/annotation")),
  list(Name = "BioCexp",  URL = paste0("https://bioconductor.org/packages/", bioc_version, "/data/experiment")),
  list(Name = "BioCworkflows", URL = paste0("https://bioconductor.org/packages/", bioc_version, "/workflows"))
)

# 3. Update the global repositories list
# Ensure CRAN is preserved and Bioconductor repos are named correctly
cran_url <- "https://cloud.r-project.org"
for (repo in lock$R$Repositories) {
  if (repo$Name == "CRAN") cran_url <- repo$URL
}

lock$R$Repositories <- c(
  list(list(Name = "CRAN", URL = cran_url)),
  bioc_repos
)

# 4. Surgical update for package sources
# Rename any "Bioconductor X.YY" to "BioCsoft" or "BioCann"
ann_pkgs <- c("org.Hs.eg.db", "org.Mm.eg.db", "GenomeInfoDbData")

if (!is.null(lock$Packages)) {
  for (pkg_name in names(lock$Packages)) {
    pkg <- lock$Packages[[pkg_name]]
    if (identical(pkg$Source, "Bioconductor")) {
      repo <- if (pkg_name %in% ann_pkgs) "BioCann" else "BioCsoft"
      lock$Packages[[pkg_name]]$Repository <- repo
    }
  }
}

# 5. Write back the cleaned lockfile
write(toJSON(lock, auto_unbox = TRUE, pretty = TRUE), lock_path)
cat("Successfully standardized renv.lock repository names.\n")
