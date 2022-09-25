import Files
import XCTest
@testable import MyApp

final class MyAppTests: XCTestCase {

    private let cmd = "MyApp "

    private var testFolder: Folder!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let productsFolder = try Folder(path: productsDirectory.path)
        testFolder = try productsFolder.createSubfolderIfNeeded(withName: "TestDirectory")
        try testFolder.empty()
        try testFolder.createSubfolder(at: "Subfolder")
        try testFolder.createSubfolder(at: ".hiddenFolder")
        try testFolder.createFile(at: ".hiddenFile")
        try testFolder.createFile(at: "MyApp.swift")
        try testFolder.createFile(at: "README.md")
    }

    override func tearDownWithError() throws {
        try? testFolder.delete()
        try super.tearDownWithError()
    }

    // MARK: - list

    func test_list() throws {
        try AssertExecuteCommand(command: cmd + testFolder.path, expected: """
        -- TestDirectory --
        MyApp.swift
        README.md
        """)
    }

    func test_list_directories() throws {
        let expected = """
        -- TestDirectory --
        [Subfolder]
        MyApp.swift
        README.md
        """
        try AssertExecuteCommand(command: cmd + "-d " + testFolder.path, expected: expected)
        try AssertExecuteCommand(command: cmd + "--directories " + testFolder.path, expected: expected)
    }

    func test_list_hidden() throws {
        let expected = """
        -- TestDirectory --
        .hiddenFile
        MyApp.swift
        README.md
        """
        try AssertExecuteCommand(command: cmd + "-i " + testFolder.path, expected: expected)
        try AssertExecuteCommand(command: cmd + "--include-hidden " + testFolder.path, expected: expected)
    }

    func test_list_directoriesAndHidden() throws {
        let expected = """
        -- TestDirectory --
        [.hiddenFolder]
        [Subfolder]
        .hiddenFile
        MyApp.swift
        README.md
        """
        try AssertExecuteCommand(command: cmd + "-di " + testFolder.path, expected: expected)
        try AssertExecuteCommand(command: cmd + "--directories --include-hidden " + testFolder.path, expected: expected)
    }

    func test_list_filter() throws {
        let expected = """
        -- TestDirectory --
        [.hiddenFolder]
        [Subfolder]
        """
        print(testFolder.path)
        try AssertExecuteCommand(command: cmd + testFolder.path + " -di -f older", expected: expected)
        try AssertExecuteCommand(command: cmd + testFolder.path + " --directories --include-hidden --filter older",
                                 expected: expected)
    }

    // MARK: - name-length

    func test_nameLength() throws {
        try AssertExecuteCommand(command: cmd + "name-length " + testFolder.path, expected: """
        -- TestDirectory --
        11
        9
        """)
    }

    // MARK: - help

    func test_help() throws {
        let helpText = """
        OVERVIEW: A neat little tool to list files and directories

        USAGE: my-app <subcommand>

        OPTIONS:
          --version               Show the version.
          -h, --help              Show help information.

        SUBCOMMANDS:
          list (default)
          name-length

          See 'my-app help <subcommand>' for detailed help.
        """

        try AssertExecuteCommand(command: cmd + "-h", expected: helpText)
        try AssertExecuteCommand(command: cmd + "--help", expected: helpText)
        try AssertExecuteCommand(command: cmd + "help", expected: helpText)
    }

    func testList_help() throws {
        let helpText = """
        USAGE: my-app list [<path>] [--directories] [--include-hidden] [--filter <filter>]

        ARGUMENTS:
          <path>                  Path of the directory to be listed (default: .)

        OPTIONS:
          -d, --directories       Include directories
          -i, --include-hidden    Include hidden files/directories
          -f, --filter <filter>   Filter the list of files and directories
          --version               Show the version.
          -h, --help              Show help information.
        """

        try AssertExecuteCommand(command: cmd + "list -h", expected: helpText)
        try AssertExecuteCommand(command: cmd + "list --help", expected: helpText)
        try AssertExecuteCommand(command: cmd + "help list", expected: helpText)
    }

    func testNameLength_help() throws {
        let helpText = """
        USAGE: my-app name-length [<path>] [--directories] [--include-hidden] [--filter <filter>]

        ARGUMENTS:
          <path>                  Path of the directory to be listed (default: .)

        OPTIONS:
          -d, --directories       Include directories
          -i, --include-hidden    Include hidden files/directories
          -f, --filter <filter>   Filter the list of files and directories
          --version               Show the version.
          -h, --help              Show help information.
        """

        try AssertExecuteCommand(command: cmd + "name-length -h", expected: helpText)
        try AssertExecuteCommand(command: cmd + "name-length --help", expected: helpText)
        try AssertExecuteCommand(command: cmd + "help name-length", expected: helpText)
    }
}
