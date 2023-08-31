{
  config,
  lib,
  ...
}: {
  options.local.programs.htop = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf config.local.programs.htop.enable {
    home.file.".config/htop/htoprc".text = ''
      htop_version=3.2.2
      config_reader_min_version=3
      fields=0 48 46 47 49 1
      hide_kernel_threads=1
      hide_userland_threads=0
      hide_running_in_container=0
      shadow_other_users=1
      show_thread_names=1
      show_program_path=0
      highlight_base_name=1
      highlight_deleted_exe=1
      shadow_distribution_path_prefix=1
      highlight_megabytes=1
      highlight_threads=1
      highlight_changes=0
      highlight_changes_delay_secs=5
      find_comm_in_cmdline=0
      strip_exe_from_cmdline=0
      show_merged_command=0
      header_margin=0
      screen_tabs=0
      detailed_cpu_time=0
      cpu_count_from_one=1
      show_cpu_usage=1
      show_cpu_frequency=0
      show_cpu_temperature=0
      degree_fahrenheit=0
      update_process_names=0
      account_guest_in_cpu_meter=0
      color_scheme=0
      enable_mouse=1
      delay=15
      hide_function_bar=2
      header_layout=two_50_50
      column_meters_0=LeftCPUs4 CPU MemorySwap
      column_meter_modes_0=1 1 1
      column_meters_1=RightCPUs4 NetworkIO DiskIO
      column_meter_modes_1=1 2 2
      tree_view=1
      sort_key=1
      tree_sort_key=0
      sort_direction=1
      tree_sort_direction=1
      tree_view_always_by_pid=1
      all_branches_collapsed=1
      screen:Main=PID USER PERCENT_CPU PERCENT_MEM TIME Command
      .sort_key=Command
      .tree_sort_key=PID
      .tree_view=1
      .tree_view_always_by_pid=1
      .sort_direction=1
      .tree_sort_direction=1
      .all_branches_collapsed=1
      screen:I/O=PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE PERCENT_SWAP_DELAY PERCENT_IO_DELAY Command
      .sort_key=IO_RATE
      .tree_sort_key=PID
      .tree_view=0
      .tree_view_always_by_pid=0
      .sort_direction=-1
      .tree_sort_direction=1
      .all_branches_collapsed=0
      screen:New=STATE PRIORITY NICE STARTTIME M_VIRT M_RESIDENT M_SHARE PERCENT_CPU PERCENT_MEM USER TIME IO_PRIORITY CWD EXE COMM PID Command
      .sort_key=PID
      .tree_sort_key=PID
      .tree_view=0
      .tree_view_always_by_pid=0
      .sort_direction=1
      .tree_sort_direction=1
          .all_branches_collapsed=0
    '';
  };
}
