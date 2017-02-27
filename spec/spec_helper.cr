require "spec"
require "webmock"
require "../src/bugsnag"

Spec.before_each &->WebMock.reset

class BugsnagTestError < Exception
  def backtrace
    [
      "0x467fe4: *IO::FileDescriptor#unbuffered_write<Slice(UInt8)>:Int32 at /opt/crystal/src/io/file_descriptor.cr 274:11",
      "0x4683ad: *IO::FileDescriptor at /opt/crystal/src/io/buffered.cr 266:5",
      "0x468536: *IO::FileDescriptor at /opt/crystal/src/io/buffered.cr 237:7",
      "0x461420: *Char#to_s<IO::FileDescriptor>:(IO::FileDescriptor | Int32 | Nil) at /opt/crystal/src/char.cr 771:9",
      "0x468455: *IO::FileDescriptor at /opt/crystal/src/io.cr 266:5",
      "0x468436: *IO::FileDescriptor at /opt/crystal/src/io.cr 280:5",
      "0x46842b: *IO::FileDescriptor at /opt/crystal/src/io.cr 335:5",
      "0x467838: *IO::FileDescriptor at /opt/crystal/src/io.cr 310:5",
      "0x44adc8: *puts<String>:Nil at /opt/crystal/src/kernel.cr 82:3",
      "0x481a41: *Bugsnag::notify<Exception+>:Nil at /home/gewo/dev/bugsnag.cr/src/bugsnag.cr 14:5",
      "0x43c7a3: ??? at /home/user/dev/bugsnag.cr/test.cr 4:3",
      "0x44a8d9: main at /home/user/.cache/crystal/macro79937040.cr 12:15",
      "0x7f9764ac7b45: __libc_start_main at ??",
      "0x43c089: ??? at ??",
      "0x0: ??? at ??",
    ]
  end

  def message
    "App crashed!"
  end
end
