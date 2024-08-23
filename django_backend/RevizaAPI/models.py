from django.db import models
import os

class StudyMaterial(models.Model):
    TYPE_CHOICES = [
        ('NOTE', 'Note'),
        ('BOOK', 'Book'),
        ('VIDEO', 'Video'),
        # Add more types as needed
    ]

    type = models.CharField(max_length=50, choices=TYPE_CHOICES)
    id = models.CharField(max_length=255, primary_key=True)
    subject_name = models.CharField(max_length=255)
    title = models.CharField(max_length=255)
    description = models.TextField()

    # FileField for storing file uploads
    file = models.FileField(upload_to='study_materials/', null=True, blank=True)

    size = models.CharField(max_length=50, null=True, blank=True)

    fans = models.JSONField(default=list)
    haters = models.JSONField(default=list)
    reports = models.JSONField(default=list)

    def __str__(self):
        return f"{self.title} ({self.subject_name})"
    
    def save(self, *args, **kwargs):
        # Automatically calculate the size of the file
        if self.file:
            self.size = self.get_file_size(self.file.size)
        super().save(*args, **kwargs)
    
    def get_file_size(self, size_in_bytes):
        if size_in_bytes < 1024:
            return f"{size_in_bytes} bytes"
        elif size_in_bytes < 1024 * 1024:
            return f"{size_in_bytes / 1024:.2f} KB"
        elif size_in_bytes < 1024 * 1024 * 1024:
            return f"{size_in_bytes / (1024 * 1024):.2f} MB"
        else:
            return f"{size_in_bytes / (1024 * 1024 * 1024):.2f} GB"

    def to_json(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'file_url': self.file.url if self.file else None,
            'subject_name': self.subject_name,
            'type': self.type,
            'fans': self.fans,
            'haters': self.haters,
            'reports': self.reports,
            'size': self.size,
        }
    
    @classmethod
    def from_json(cls, data):
        return cls(
            id=data.get('id'),
            title=data.get('title'),
            description=data.get('description'),
            file=data.get('file'),
            subject_name=data.get('subject_name'),
            type=data.get('type'),
            fans=data.get('fans', []),
            haters=data.get('haters', []),
            reports=data.get('reports', []),
            size=data.get('size'),
        )
