// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// Essa classe é gerada automaticamente pelo build_runner
// Ela ensina o Hive como transformar um objeto Todo em bytes (serialização)
// e como reconstruir o objeto a partir desses bytes (deserialização)
class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  // Lê os dados do armazenamento e reconstrói o objeto Todo
  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte(); // Quantos campos o objeto tem
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
    );
  }

  // Escreve o objeto Todo no formato binário que o Hive entende
  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(2)               // Quantidade de campos que serão escritos
      ..writeByte(0)               // Índice do campo 0
      ..write(obj.title)           // Valor do campo title
      ..writeByte(1)               // Índice do campo 1
      ..write(obj.isCompleted);    // Valor do campo isCompleted
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}