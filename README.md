# Fozzy Group test task

Ответ на тестовое задание от Fozzy Group.

## Первое задание

В первом задании пришлось проитерировать таблицу, сначала пытался через CURSOR, но это не позволило бы итерировать вторую таблицу внутри первого цикла.

## Второе задание

Берем промежуток от min max и заполняем в цикле числами временную таблицу. 

В качестве небольшой оптимизации заполняем сразу по 10 чисел одним `INSERT`.

Затем простым запросом удаляем лишние числа.

Время исполнения на промежутке от -500000 до 500000 около 2 сек.