# 💤 LazyVim Config: Java & Salesforce Development

This repository contains my personal Neovim configuration, built on top of [LazyVim](https://github.com/LazyVim/LazyVim). It is heavily customized and optimized for a robust Full-Stack and Salesforce development workflow.

##  Features

This setup provides tailored support, Language Server Protocol (LSP) integration, and formatting for the following ecosystem:

* **Backend:** Java & Spring Boot (via `jdtls`)

* **Frontend:** Angular (via `angularls` / `typescript-language-server`)

* **Salesforce:**
    * Apex
    * LWC
    * Deep integration with Salesforce CLI via [sf.nvim](https://github.com/xixiaofinland/sf.nvim)

* **Custom Enhancements:**
    * Tailored development shortcuts specifically for Salesforce push/pull/deploy cycles.
    * Personalized snippet collection for boilerplate reduction in Spring and LWC.

##  Prerequisites

Ensure you have the following dependencies installed on your system before proceeding:

* **Neovim** >= 0.9.0
* **Git**
* **Node.js** & **npm** (Required for Angular LSP, LWC, and general web tooling)
* **Java JDK** >= 17 (Required for `jdtls` and Spring Boot)
* **Salesforce CLI (`sf`)** (Required for `sf.nvim` functionality)
* A Nerd Font (Optional, but highly recommended for UI icons)

## Remembering

This is not a tutorial or a installation guide, it is important that you discover/debug things by yourself.
