# build.tcl
open_project otladka_urr/otladka_urr.xpr

puts "=== Запуск синтеза ==="
launch_runs synth_1 -jobs 4
wait_on_run synth_1

puts "=== Запуск реализации и генерация битстрима ==="
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts "=== Сборка завершена! ==="