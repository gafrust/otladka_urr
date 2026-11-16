# 📘 Проект `otladka_urr` — инструкция по сборке и работе

## 📋 Содержание

1. [Структура проекта](#-структура-проекта)
2. [Требования](#-требования)
3. [Быстрый старт: сборка одной командой](#-быстрый-старт-сборка-одной-командой)
4. [Выбор варианта теста](#-выбор-варианта-теста)
5. [Настройка ILA через Set up Debug](#-настройка-ila-через-set-up-debug)
6. [Загрузка битстрима на плату](#-загрузка-битстрима-на-плату)
7. [Работа через GUI Vivado](#-работа-через-gui-vivado)
8. [Структура репозитория](#-структура-репозитория)
9. [Типичные проблемы](#-типичные-проблемы)
10. [Типичный рабочий цикл](#-типичный-рабочий-цикл)

---

## 📁 Структура проекта

```
otladka_urr/
├── rtl_dir/              # RTL-исходники (Verilog)
│   ├── urr.v              # Верхний модуль
│   ├── urr_osn.v          # Основной модуль
│   ├── urr_crc*.v         # Модули CRC
│   ├── urr_uart_*.v       # UART приёмник/передатчик
│   ├── urr_fifo_200.v     # FIFO
│   └── ...
├── test/
│   └── test_urr2.v        # Тестбенч с 4 вариантами тестов
├── const/
│   ├── const.xdc          # Констрейнты (пины, тайминги)
│   └── constr_ila.xdc     # Констрейнты ILA (генерируется Set up Debug)
├── recreate_project.tcl   # Скрипт воссоздания проекта Vivado
├── build.tcl              # Скрипт запуска синтеза и реализации
├── build.sh               # Bash-скрипт для полной сборки
├── otladka_urr.xpr        # Файл проекта Vivado (для GUI)
└── .gitignore
```

---

## 🛠 Требования

| Компонент | Версия | Примечание |
|---|---|---|
| **Vivado** | 2023.2 | Должен быть в `$PATH` (проверьте `which vivado`) |
| **Bash** | любая | Linux / WSL |
| **Плата** | Kintex-7 `xc7k160tiffg676-2L` | Указана в проекте |
| **Git** | любая | Для клонирования репозитория |

Проверка перед началом:
```bash
which vivado          # должно вывести /opt/Xilinx.../Vivado/2023.2/bin/vivado
vivado -version       # должно показать Vivado v2023.2
```

---

## 🚀 Быстрый старт: сборка одной командой

### 1. Клонирование репозитория

```bash
git clone <URL_репозитория>
cd otladka_urr
```

### 2. Запуск сборки

```bash
./build.sh
```

Скрипт выполнит **всё автоматически**:

1. Очистит папку `build/`
2. Воссоздаст проект Vivado из `recreate_project.tcl`
3. Импортирует исходники из `rtl_dir/`, `test/`, `const/`
4. Запустит синтез (`synth_1`)
5. Запустит реализацию (`impl_1`) и сгенерирует битстрим

⏱ **Время сборки:** 5–15 минут в зависимости от загрузки CPU.

### 3. Результат

Готовый битстрим будет находиться по пути:

```
build/otladka_urr/otladka_urr.runs/impl_1/urr.bit
```

---

## 🧪 Выбор варианта теста

В файле **`test/test_urr2.v`** реализованы **4 варианта тестов**. Активен всегда **только один** — остальные три должны быть **закомментированы**.

Перед каждой сборкой откройте `test/test_urr2.v` и раскомментируйте нужный блок.

### Вариант 1 — Тест частоты (`freq`)

```verilog
// ============================================================
// ВАРИАНТ 1: Тест частоты
// ============================================================
`define TEST_FREQ
// `define TEST_CRC
// `define TEST_NO_CONNECT_CRC
// `define TEST_NO_CONNECT_FREQ
```

**Что делает:** генерирует тестовый сигнал определённой частоты. Используется для проверки тактирования и делителей частоты.

---

### Вариант 2 — Тест CRC (`crc`)

```verilog
// ============================================================
// ВАРИАНТ 2: Тест CRC
// ============================================================
// `define TEST_FREQ
`define TEST_CRC
// `define TEST_NO_CONNECT_CRC
// `define TEST_NO_CONNECT_FREQ
```

**Что делает:** прогоняет данные через модуль CRC и проверяет корректность контрольных сумм.

---

### Вариант 3 — Тест без подключения CRC (`no connect crc`)

```verilog
// ============================================================
// ВАРИАНТ 3: Тест без подключения CRC
// ============================================================
// `define TEST_FREQ
// `define TEST_CRC
`define TEST_NO_CONNECT_CRC
// `define TEST_NO_CONNECT_FREQ
```

**Что делает:** имитирует работу системы, в которой модуль CRC **отключён** (обход). Полезно для отладки, когда нужно изолировать проблему в CRC.

---

### Вариант 4 — Тест без подключения freq (`no connect freq`)

```verilog
// ============================================================
// ВАРИАНТ 4: Тест без подключения freq
// ============================================================
// `define TEST_FREQ
// `define TEST_CRC
// `define TEST_NO_CONNECT_CRC
`define TEST_NO_CONNECT_FREQ
```

**Что делает:** имитирует работу системы без модуля формирования частоты.

---

### ⚠️ Важно

- **Раскомментирован должен быть РОВНО ОДИН `define`**. Если активны два и более — будет конфликт.
- После изменения `test_urr2.v` **обязательно пересоберите проект** (`./build.sh`).
- Имя верхнего модуля (`urr`) и имя тестбенча (`test_urr2`) менять не нужно — они уже прописаны в `recreate_project.tcl`.

---

## 🔬 Настройка ILA через Set up Debug

**ILA** (Integrated Logic Analyzer) — это встроенный в FPGA логический анализатор. В Vivado он добавляется **не вручную через инстанс в коде**, а через мастер **Set up Debug**, который:
1. Берёт сигналы из **синтезированной схемы** (netlist).
2. Автоматически создаёт IP-ядро ILA.
3. Генерирует файл констрейнтов (`constr_ila.xdc`), где прописаны все подключения проб.

Это удобнее и безопаснее, потому что вы видите реальные имена сигналов после синтеза (с учётом оптимизации).

### Шаг 1: Открыть проект в GUI

```bash
vivado otladka_urr.xpr &
```

*(Используйте оригинальный `.xpr` в корне репозитория, а не тот, что в `build/`.)*

### Шаг 2: Запустить синтез

В Vivado:

```
Flow Navigator → SYNTHESIS → Run Synthesis
```

Дождитесь окончания (5–10 минут). Без синтеза Set up Debug не сможет показать список сигналов.

### Шаг 3: Открыть синтезированный дизайн

```
Flow Navigator → SYNTHESIS → Open Synthesized Design
```

### Шаг 4: Запустить мастер Set up Debug

```
Flow Navigator → SYNTHESIS → Set up Debug
```

*(Или: правой кнопкой по `Synthesized Design` → Set up Debug.)*

Откроется пошаговый мастер:

#### Шаг 4.1 — Specify Clock Domain

Выберите **тактовый домен**, к которому относятся сигналы, которые вы хотите смотреть. Обычно это `clk` вашего верхнего модуля (например, `clk_IBUF` или `clk`).

> ⚠️ Если сигналы находятся в разных тактовых доменах — создайте **несколько** ILA-ядер (по одному на каждый клок). В одном ILA все пробы должны быть синхронны одному клоку.

#### Шаг 4.2 — Select Nets to Debug

Нажмите **«+»** (Add Nets) → откроется окно **Find Nets to Add**:

1. В поле **Search** введите имя сигнала (например, `urr_osn`, `crc`, `data`, `state`).
2. Отметьте галочками нужные сигналы в списке.
3. Нажмите **OK**.

Выбранные сигналы появятся в таблице. Для каждого можно задать:
- **Sample depth** — глубина буфера (по умолчанию 1024, можно 2048, 4096 и т.д.). Чем больше — тем больше BRAM тратится.
- **Probe width** — ширина шины (определяется автоматически, но можно поправить).

> 💡 **Совет:** Не добавляйте слишком много сигналов. Каждый сигнал тратит BRAM, а на Kintex-7 его не бесконечно. 10–15 проб при глубине 1024 — нормально.

#### Шаг 4.3 — (Опционально) Summary

Проверьте итоговую конфигурацию. Нажмите **Finish**.

### Шаг 5: Сохранить констрейнты

После Finish Vivado создаст файл констрейнтов для ILA. По умолчанию он называется `constr_ila.xdc` или `debug.xdc`.

1. Нажмите **`Ctrl + S`** (Save Constraints).
2. Vivado спросит имя файла — укажите, например, `constr_ila`.
3. Файл будет создан в `otladka_urr.srcs/constrs_1/new/` (по умолчанию).

### Шаг 6: Переместить `constr_ila.xdc` в папку `const/`

Чтобы файл не игнорировался Git (папка `.srcs/` в `.gitignore`), переместите его:

1. В панели **Sources** найдите `constr_ila.xdc`.
2. Правой кнопкой → **Move File...**
3. Выберите папку `const/` в корне проекта.
4. Нажмите **OK**.

Теперь файл лежит в `const/constr_ila.xdc` и будет отслеживаться Git.

### Шаг 7: Пересобрать битстрим с ILA

```
Flow Navigator → IMPLEMENTATION → Generate Bitstream
```

Vivado выполнит синтез (уже с ILA), реализацию и сгенерирует `urr.bit`, содержащий логический анализатор.

### Шаг 8: Перегенерировать `recreate_project.tcl`

Чтобы `./build.sh` в дальнейшем включал ILA, скрипт воссоздания проекта должен знать про `constr_ila.xdc`. В Tcl Console:

```tcl
cd /home/rgafurov/work/Praktika_FPGA/Rustem_Gafurov/Radiocomp/URR2/github/otladka_urr
write_project_tcl -force -paths_relative_to . recreate_project.tcl
```

Проверьте: в шапке нового `recreate_project.tcl` должен появиться путь `const/constr_ila.xdc`, а в блоке `set files` для `constrs_1` — строка:

```tcl
set file "[file normalize "$origin_dir/const/constr_ila.xdc"]"
```

### Шаг 9: Закоммитить изменения

```bash
git add const/constr_ila.xdc recreate_project.tcl
git commit -m "Добавлены ILA-пробы через Set up Debug"
git push
```

Теперь любой, кто склонирует репозиторий и запустит `./build.sh`, получит битстрим **с теми же ILA-пробами**.

### 🔄 Как изменить набор сигналов в ILA

1. Откройте проект в GUI.
2. `Flow Navigator → SYNTHESIS → Open Synthesized Design`.
3. **`Flow Navigator → SYNTHESIS → Set up Debug`** — мастер откроется с **уже существующими** пробами.
4. В шаге **Select Nets to Debug** добавьте/удалите сигналы.
5. `Ctrl + S` → сохраните `constr_ila.xdc`.
6. Пересоберите битстрим (`Generate Bitstream`).
7. Перегенерируйте `recreate_project.tcl` (шаг 8).
8. Закоммитьте `const/constr_ila.xdc` и `recreate_project.tcl`.

> 💡 **Важно:** не редактируйте `constr_ila.xdc` руками. Все изменения — только через мастер Set up Debug, иначе можно сломать привязку проб к нетам.

### ⚠️ Важно про ILA

- **Каждый probe тратит BRAM.** Не добавляйте больше 10–15 проб при глубине 1024.
- **Тактовая частота ILA** = частота выбранного клока. Если сигналы в другом домене — нужен отдельный ILA.
- **ILA работает только при прошивке через JTAG** (Hardware Manager). При загрузке из flash-памяти ILA не активен.
- **После Set up Debug обязательно пересоберите битстрим** — иначе ILA не попадёт в FPGA.

---

## 📥 Загрузка битстрима на плату

### Вариант 1: Через GUI Vivado (для отладки с ILA) — **основной**

1. Подключите плату к ПК через JTAG-кабель.
2. Включите питание платы.
3. Откройте **Hardware Manager**:
   ```
   Flow Navigator → PROGRAM AND DEBUG → Open Hardware Manager
   ```
4. **Open target → Auto Connect**.
5. **Program device** → выберите `build/otladka_urr/otladka_urr.runs/impl_1/urr.bit`.
6. После прошивки откроется окно **ILA Dashboard** — там будут осциллограммы.

### Вариант 2: Через Tcl (без ILA)

Если ILA не используется и нужна только прошивка:

```tcl
# program.tcl
open_hw_manager
connect_hw_server
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [current_hw_device]
set_property PROGRAM.FILE {build/otladka_urr/otladka_urr.runs/impl_1/urr.bit} [current_hw_device]
program_hw_devices [current_hw_device]
```

Запуск:
```bash
vivado -mode batch -source program.tcl
```

### 🔧 Включение блока после прошивки

После загрузки битстрима система **начинает работать автоматически**. Проверьте:

- Питание платы в норме (индикаторы горят).
- Тактовый генератор подключён.
- Сигнал сброса снят (кнопка `rst` отпущена).
- В ILA Dashboard нажмите **Run Trigger** (▶), предварительно настроив условие триггера.

---

## 🖥 Работа через GUI Vivado

Если вы хотите работать в интерактивном режиме (править код, смотреть схемы, настраивать ILA):

```bash
vivado otladka_urr.xpr &
```

### ⚠️ Правила работы через GUI

1. **Не редактируйте файлы внутри `build/`** — они перезаписываются при `./build.sh`.
2. **Все правки вносите в `rtl_dir/`, `test/`, `const/`.**
3. **После изменения структуры проекта** (добавление/удаление файлов, изменения IP, Set up Debug) — **перегенерируйте** `recreate_project.tcl`:
   ```tcl
   cd /path/to/otladka_urr
   write_project_tcl -force -paths_relative_to . recreate_project.tcl
   ```
4. **После правок в GUI** — закоммитьте изменения и запустите `./build.sh` для проверки, что сборка из скрипта тоже работает.

---

## 📂 Структура репозитория (что коммитить)

| Файл / папка | В Git | Примечание |
|---|---|---|
| `rtl_dir/` | ✅ | Исходники RTL |
| `test/` | ✅ | Тестбенч |
| `const/const.xdc` | ✅ | Основные констрейнты |
| `const/constr_ila.xdc` | ✅ | Констрейнты ILA (генерируются Set up Debug) |
| `recreate_project.tcl` | ✅ | Скрипт воссоздания |
| `build.sh`, `build.tcl` | ✅ | Скрипты сборки |
| `otladka_urr.xpr` | ✅ | Для GUI (опционально) |
| `.gitignore` | ✅ | |
| `build/` | ❌ | Игнорируется |
| `otladka_urr.srcs/` | ❌ | Игнорируется (старое) |
| `otladka_urr.runs/` | ❌ | Игнорируется |
| `otladka_urr.cache/` | ❌ | Игнорируется |

---

## 🐛 Типичные проблемы

### ❌ `vivado: command not found`

**Причина:** Vivado не в `$PATH`.

**Решение:** добавьте в `~/.bashrc`:
```bash
source /opt/Xilinx/Vivado/2023.2/settings64.sh
```
И перезапустите терминал.

---

### ❌ `Could not find local file ...`

**Причина:** `recreate_project.tcl` ссылается на файл, которого нет.

**Решение:**
1. Проверьте, что все файлы из шапки `recreate_project.tcl` существуют в `rtl_dir/`, `test/`, `const/`.
2. Если файл переехал — обновите `recreate_project.tcl`:
   ```tcl
   cd /path/to/otladka_urr
   write_project_tcl -force -paths_relative_to . recreate_project.tcl
   ```

---

### ❌ `ERROR: Project file does not exist`

**Причина:** сборка упала на этапе `recreate_project.tcl` (см. ошибку выше по логу).

**Решение:** посмотрите лог выше — там будет конкретная причина.

---

### ❌ ILA не показывает сигналы

**Причина:** триггер не сработал, ILA не тактируется, или ILA не попал в битстрим.

**Решение:**
1. Убедитесь, что после Set up Debug вы **пересобрали битстрим** (`Generate Bitstream`).
2. Проверьте, что `.clk` ILA подключён к реальному клоку (шаг 4.1 мастера).
3. В ILA Dashboard настройте триггер: **Trigger Setup** → добавьте условие (например, `probe0 == 1`).
4. Нажмите **Run Trigger** (▶).

---

### ❌ Не собирается после переименования файла

**Причина:** `recreate_project.tcl` всё ещё ссылается на старое имя.

**Решение:** перегенерируйте скрипт:
```tcl
cd /path/to/otladka_urr
write_project_tcl -force -paths_relative_to . recreate_project.tcl
```

---

### ❌ Set up Debug не показывает сигналы

**Причина:** не открыт синтезированный дизайн, или синтез не выполнен.

**Решение:** сначала `Run Synthesis`, затем `Open Synthesized Design`, и только потом `Set up Debug`.

---

## 🔄 Типичный рабочий цикл

```
┌────────────────────────────────────────────────────────┐
│ 1. git pull                                            │
├────────────────────────────────────────────────────────┤
│ 2. Открыть test/test_urr2.v                            │
│    → раскомментировать нужный TEST_*                   │
├────────────────────────────────────────────────────────┤
│ 3. (опционально) Настроить ILA:                        │
│    → Open Synthesized Design                           │
│    → Set up Debug → выбрать сигналы                    │
│    → Сохранить const/constr_ila.xdc                    │
│    → write_project_tcl -force -paths_relative_to .     │
│    → git add const/constr_ila.xdc recreate_project.tcl │
├────────────────────────────────────────────────────────┤
│ 4. ./build.sh                                          │
├────────────────────────────────────────────────────────┤
│ 5. Открыть Hardware Manager                            │
│    → Program Device → urr.bit                          │
├────────────────────────────────────────────────────────┤
│ 6. Настроить триггер ILA → Run Trigger                 │
├────────────────────────────────────────────────────────┤
│ 7. Анализ осциллограмм                                 │
└────────────────────────────────────────────────────────┘
```

---

## 📞 Ссылки

- **Vivado Documentation:** [UG893 (Using the Vivado IDE)](https://docs.xilinx.com/r/en-US/ug893-vivado-ide)
- **Tcl Commands Reference:** [UG835 (Vivado Design Suite Tcl Command Reference)](https://docs.xilinx.com/r/en-US/ug835-vivado-tcl-commands)
- **ILA User Guide:** [PG172 (Integrated Logic Analyzer)](https://docs.xilinx.com/r/en-US/pg172-ila)
- **Set up Debug (UG908):** [Programming and Debugging](https://docs.xilinx.com/r/en-US/ug908-vivado-programming-debugging)

---

*Последнее обновление: ноябрь 2026*
