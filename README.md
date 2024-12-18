# Faktur

Faktur is a simple CLI tool to generate invoices.

## Installation

To install Faktur, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/vicentedpsantos/faktur.git
    ```
2. Navigate to the project directory:
    ```sh
    cd faktur
    ```
3. Install the necessary dependencies:
    ```sh
    make install
    ```

4. To uninstall Faktur, run the following command:
    ```sh
    make uninstall
    ```

## Usage

Faktur provides several commands to manage configurations and invoices. All flags are optional, and the user can run the commands without any flags.

### Configuration Commands

- **Create a new configuration:**
    ```sh
    faktur configurations create <NAME>
    ```

- **List all configurations:**
    ```sh
    faktur configurations list
    ```

- **Delete a configuration:**
    ```sh
    faktur configurations delete <ID>
    ```

- **Show a specific configuration:**
    ```sh
    faktur configurations show <NAME>
    ```

### Invoice Commands

- **Create a new invoice:**
    ```sh
    faktur invoices create --number=<NUMBER>
    ```

- **List all invoices:**
    ```sh
    faktur invoices list
    ```

- **Delete an invoice:**
    ```sh
    faktur invoices delete <ID>
    ```

- **Print an invoice:**
    ```sh
    faktur invoices print <ID>
    ```

## Examples

- Create a new configuration named "default":
    ```sh
    faktur configurations create default
    ```

- Create a new invoice with a specific number:
    ```sh
    faktur invoices create --number=12345
    ```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
