import Foundation
public class BoundStreams {
    public let input: InputStream
    public let output: OutputStream

    public init() {
        var inputOrNil: InputStream?
        var outputOrNil: OutputStream?
        Stream.getBoundStreams(withBufferSize: 40960,
                inputStream: &inputOrNil,
                outputStream: &outputOrNil)
        guard let input = inputOrNil, let output = outputOrNil else {
            fatalError("On return of `getBoundStreams`, both `inputStream` and `outputStream` will contain non-nil streams.")
        }

        self.input = input
        self.output = output
    }
}
