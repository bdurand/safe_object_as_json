# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0

### Added
- Re-implement Object#as_json to omit circular dependencies in internal object references.
- Omit Proc and IO objects from being included in Object#as_json result.
