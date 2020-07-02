# CHANGELOG

All notable changes to this project will be documented in this file.

## v0.5.4 (2020-07-02)
### 🆕 Bug fixes
* Fix invalid annotation level of `backoffLimit` within initDBHook Job template 

## v0.5.3 (2020-06-25)
### 🆕 Features
* Allow users to define a custom `backoffLimit` for initDBHook Job. (Default value set to 6)
* Enabling initDBHook and initContainers Jobs by default. 

## v0.5.2 (2020-05-19)

### Features
* Allow exposition of both HTTP & gRPC endpoints in the ingress with more flexibility

### ⚠ BREAKING CHANGES
* Change default port of gRPC from `80` to `8080`
