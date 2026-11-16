==#!/bin/bash

BUILD_DIR="build"

# 1. Очищаем старую сборку
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# 2. Воссоздаем проект.
echo "=== Воссоздание проекта ==="
# ИСПРАВЛЕНИЕ: флаг -notrace перенесен ВПЕРЕД -source и -tclargs
vivado -mode batch -notrace -source ../recreate_project.tcl -tclargs --origin_dir ..

# Проверяем, создался ли проект (так как Vivado может вернуть 0 при ошибке Tcl)
if [ ! -f "otladka_urr/otladka_urr.xpr" ]; then
    echo "ОШИБКА: Проект не был создан. Проверьте вывод Vivado выше."
    exit 1
fi

# 3. Запускаем сборку
echo "=== Запуск сборки битстрима ==="
vivado -mode batch -notrace -source ../build.tcl

# Проверяем, создался ли битстрим (верхний модуль у вас urr, значит файл urr.bit)
if [ ! -f "otladka_urr/otladka_urr.runs/impl_1/urr.bit" ]; then
    echo "ОШИБКА: Битстрим не был создан. Проверьте логи сборки."
    exit 1
fi

echo "=== Готово! Битстрим здесь: $BUILD_DIR/otladka_urr/otladka_urr.runs/impl_1/urr.bit===" 
