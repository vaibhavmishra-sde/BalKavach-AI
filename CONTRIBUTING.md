# Contributing to BalKavach AI

First off, thank you for considering contributing to BalKavach AI! It's people like you that make open source such a great community to learn, inspire, and create.

## Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/vaibhavmishra-sde/BalKavach-AI.git
   ```
3. **Set up the backend**:
   ```bash
   cd backend
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
   pip install -r requirements.txt
   ```
4. **Create a branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

- Please write clear, readable, and well-documented code.
- If you're adding an AI model, place it in the `ai_models/` directory and update the relevant `backend/services/` logic.
- Ensure all existing features (Toxicity & Image Safety) still work before submitting.

## Submitting a Pull Request

1. Commit your changes with a descriptive commit message.
2. Push your branch to your forked repository.
3. Open a Pull Request against the `main` branch of this repository.
4. Provide a clear summary of what the PR does and link to any relevant issues.

## Reporting Bugs / Requesting Features

If you find a bug or have a feature idea, please check the [Issue Tracker](../../issues) first. If it hasn't been reported, feel free to open a new issue using the provided templates.

We look forward to your contributions!
