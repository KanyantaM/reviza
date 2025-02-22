// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_material_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyMaterialAdapter extends TypeAdapter<StudyMaterial> {
  @override
  final int typeId = 1;

  @override
  StudyMaterial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyMaterial(
      downloaders: (fields[12] as List).cast<String>(),
      uploaderId: fields[11] as String,
      subjectName: fields[2] as String,
      type: fields[0] as String,
      id: fields[1] as String,
      title: fields[3] as String,
      description: fields[7] as String,
      onlinePath: fields[8] as String?,
      fans: (fields[4] as List).cast<String>(),
      haters: (fields[5] as List).cast<String>(),
      reports: (fields[6] as List).cast<String>(),
      size: fields[9] as int,
      localPath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudyMaterial obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.subjectName)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.fans)
      ..writeByte(5)
      ..write(obj.haters)
      ..writeByte(6)
      ..write(obj.reports)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.onlinePath)
      ..writeByte(9)
      ..write(obj.size)
      ..writeByte(10)
      ..write(obj.localPath)
      ..writeByte(11)
      ..write(obj.uploaderId)
      ..writeByte(12)
      ..write(obj.downloaders);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
