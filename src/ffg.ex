defmodule FFG do
  import FFmpex

  def add_stream_type_specifier(command, spec) do
    FFmpex.add_stream_specifier(command, stream_type: spec)
  end

end
