GEMSPEC = faktur.gemspec
GEM_NAME = faktur
GEM_VERSION = 0.1.0
RUBY_VERSION = 3.1.4

clean:
	@echo "Cleaning up old gem..."
	rm -f $(GEM_NAME)-$(GEM_VERSION).gem

build: clean
	@echo "Building the gem..."
	gem build $(GEMSPEC)

install: build
	@echo "Installing the gem..."
	gem install ./$(GEM_NAME)-$(GEM_VERSION).gem

uninstall:
	@echo "Uninstalling the gem..."
	gem uninstall $(GEM_NAME)

reinstall: uninstall install
	@echo "Reinstalled the gem successfully."

test: install
	@echo "Running faktur CLI..."
	faktur --help

rebuild: clean build reinstall
	@echo "Gem has been cleaned, rebuilt, and reinstalled."
