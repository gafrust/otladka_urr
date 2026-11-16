#!/bin/bash
set -e # Останавливаем скрипт при любой ошибке

BUILD_DIR="build"

# 1. Очищаем старую сборку
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# 2. Воссоздаем проект. 
# ВАЖНО: Флаг --origin_dir .. указывает скрипту, что исходники (.srcs) 
# лежат на уровень выше (в корне репозитория), а не по абсолютному пути.
echo "=== Воссоздание проекта ==="
vivado -mode batch -source ../recreate_project.tcl -tclargs --origin_dir .. -notrace

# 3. Запускаем сборку
echo "=== Запуск сборки битстрима ==="
vivado -mode batch -source ../build.tcl -notrace

echo "=== Готово! Битстрим здесь: $BUILD_DIR/otladka_urr/otladka_urr.runs/impl_1/ ==="