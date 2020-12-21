import "dart:typed_data";

import "package:meta/meta.dart";
import "package:file_picker/file_picker.dart" as picker;

import "service.dart";

typedef ProgressTracker = void Function(double);

/// Represents a file on the device. 
/// 
/// Since this app is for the web, and websites don't have access to `dart:io`, 
/// we can't simply use the `File` class. Instead, we have to make our own. 
@immutable
class FileOnDevice {
	/// The size, in bytes, of the file. 
	final int size;

	/// The stream from which to read the file. 
	final Stream<List<int>> stream;

	/// Records a file on the device. 
	const FileOnDevice({
		@required this.size,
		@required this.stream,
	});
}

/// A service to pick files from the user's device. 
class FilePicker extends Service {
	/// The amount of bytes read from the device at a time. 
	static const int bytesPerRead = 1000000;

	/// The plugin for picking files. 
	final picker.FilePicker plugin = picker.FilePicker.platform;

	@override
	Future<void> init() async {}

	/// Picks a video from the user's device. 
	Future<FileOnDevice> pickVideo() async {
		final picker.FilePickerResult result = await plugin.pickFiles(
			type: picker.FileType.video,
			withReadStream: true,
		);
		if (result == null) {
			return null;
		} else {
			final picker.PlatformFile file = result.files.first;
			return FileOnDevice(
				size: file.size,
				stream: file.readStream,
			);
		}
	}

	/// Reads a file from the device. 
	/// 
	/// Allows other functions to listen for progress updates. 
	Future<Uint8List> readFile(
		FileOnDevice file, 
		{void Function(double) progressCallback}
	) async {
		final int totalReads = file.size ~/ bytesPerRead;
		int currentRead = 0;
		final Uint8List bytes = Uint8List(file.size);
		int index = 0;

		await for (final List<int> newBytes in file.stream) {
			bytes.setRange(index, index + newBytes.length, newBytes);
			index += newBytes.length;
			progressCallback(currentRead++ / totalReads);
		}
		return bytes;
	}
}
