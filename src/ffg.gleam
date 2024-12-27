import gleam/io

pub fn main() {
  new()
  |> input_file("test.mp4")
  |> output_file("testout.mp4")
  // |> stream_type_specifier(Video)
  |> file_option(VideoFilter("scale=280:-2"))
  |> execute
  // |> prepare
  |> io.debug
}

pub type Command

pub type Option {
  // File options
  MaxRate(String)
  MinRate(String)
  FastFirstPass(Bool)
  CRF(String)
  CRFMax(String)

  // Audio options
  AudioCodec(String)

  // Video options
  VideoCodec(String)
  FrameRate(String)
  VideoFilter(String)

  // Stream options
  Bitrate(String)
}

pub type StreamSpecifier {
  Video
  VideoWithoutPics
  Audio
  Subtitle
  Data
  Attachment
}

@external(erlang, "Elixir.FFmpex", "new_command")
pub fn new() -> Command

@external(erlang, "Elixir.FFmpex", "execute")
pub fn execute(command: Command) -> Command

@external(erlang, "Elixir.FFmpex", "prepare")
pub fn prepare(command: Command) -> Command

@external(erlang, "Elixir.FFmpex", "add_input_file")
pub fn input_file(command: Command, file: String) -> Command

@external(erlang, "Elixir.FFmpex", "add_output_file")
pub fn output_file(command: Command, file: String) -> Command

fn get_option(option: Option) -> FFmpexOption {
  case option {
    MaxRate(rate) -> option_maxrate(rate)
    MinRate(rate) -> option_minrate(rate)
    FastFirstPass(bool) ->
      option_fastfirstpass(case bool {
        True -> "1"
        False -> "0"
      })
    CRF(crf) -> option_crf(crf)
    CRFMax(crf) -> option_crf_max(crf)
    AudioCodec(codec) -> option_acodec(codec)
    VideoCodec(codec) -> option_vcodec(codec)
    FrameRate(rate) -> option_r(rate)
    VideoFilter(filter) -> option_vf(filter)
    Bitrate(rate) -> option_b(rate)
  }
}

/// Add an option to the file
pub fn file_option(command: Command, option: Option) -> Command {
  get_option(option)
  |> add_file_option(command, _)
}

/// Add an option to the most recent specified stream
pub fn stream_option(command: Command, option: Option) -> Command {
  get_option(option)
  |> add_stream_option(command, _)
}

type FFmpexOption

@external(erlang, "Elixir.FFmpex", "add_file_option")
fn add_file_option(command: Command, option: FFmpexOption) -> Command

@external(erlang, "Elixir.FFG", "add_stream_type_specifier")
pub fn stream_type_specifier(
  command: Command,
  specifier: StreamSpecifier,
) -> Command

@external(erlang, "Elixir.FFmpex", "add_stream_option")
fn add_stream_option(command: Command, option: FFmpexOption) -> Command

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_maxrate")
fn option_maxrate(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_minrate")
fn option_minrate(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_fastfirstpass")
fn option_fastfirstpass(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_crf")
fn option_crf(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_crf_max")
fn option_crf_max(option: String) -> FFmpexOption

@external(erlang, "Elxir.FFmpex.Options.Video", "option_vcodec")
fn option_vcodec(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Audio", "option_acodec")
fn option_acodec(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video", "option_r")
fn option_r(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video", "option_vf")
fn option_vf(option: String) -> FFmpexOption

@external(erlang, "Elixir.FFmpex.Options.Video.Libx264", "option_b")
fn option_b(option: String) -> FFmpexOption
