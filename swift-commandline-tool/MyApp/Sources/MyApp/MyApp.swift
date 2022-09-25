import ArgumentParser
import Files

struct GlobalOptions: ParsableArguments {
    @Argument(help: "Path of the directory to be listed")
    var path: String = "."

    @Flag(name: [.customLong("directories"), .customShort("d")], help: "Include directories")
    var includeDirectories: Bool = false

    @Flag(name: .shortAndLong, help: "Include hidden files/directories")
    var includeHidden: Bool = false

    @Option(name: .shortAndLong, help: "Filter the list of files and directories")
    var filter: String?
}

@main
struct MyApp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A neat little tool to list files and directories",
        version: "1.2.3",
        subcommands: [List.self, NameLength.self],
        defaultSubcommand: List.self
    )
}

extension MyApp {
    struct List: ParsableCommand {
        @OptionGroup var args: GlobalOptions

        mutating func run() throws {
            let folder = try Folder(path: args.path)
            print("-- \(folder.name) --")
            if args.includeDirectories {
                try printDirectories()
            }
            try printFiles()
        }
    }

    struct NameLength: ParsableCommand {
        @OptionGroup var args: GlobalOptions

        mutating func run() throws {
            print("-- \(try Folder(path: args.path).name) --")
            if args.includeDirectories {
                try printDirectories()
            }
            try printFiles()
        }
    }
}

private extension MyApp.List {

    private func printFiles() throws {
        var files = try Folder(path: args.path).files

        if args.includeHidden {
            files = files.includingHidden
        }

        for file in files {
            if let filter = args.filter, !file.name.contains(filter) {
                continue
            }
            print(file.name)
        }
    }

    private func printDirectories() throws {
        var folders = try Folder(path: args.path).subfolders

        if args.includeHidden {
            folders = folders.includingHidden
        }

        for folder in folders {
            if let filter = args.filter, !folder.name.contains(filter) {
                continue
            }
            print("[\(folder.name)]")
        }
    }
}

private extension MyApp.NameLength {

    private func printFiles() throws {
        var files = try Folder(path: args.path).files

        if args.includeHidden {
            files = files.includingHidden
        }

        for file in files {
            if let filter = args.filter, !file.name.contains(filter) {
                continue
            }
            print(file.name.count)
        }
    }

    private func printDirectories() throws {
        var folders = try Folder(path: args.path).subfolders

        if args.includeHidden {
            folders = folders.includingHidden
        }

        for folder in folders {
            if let filter = args.filter, !folder.name.contains(filter) {
                continue
            }
            print("[\(folder.name.count)]")
        }
    }
}
