from django.db import models
import uuid
from django.utils.translation import gettext_lazy as _

class University(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Faculty(models.Model):
    university = models.ForeignKey(University, related_name='faculties', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Program(models.Model):
    faculty = models.ForeignKey(Faculty, related_name='programs', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Year(models.Model):
    program = models.ForeignKey(Program, related_name='years', on_delete=models.CASCADE)
    year_number = models.PositiveIntegerField()

    def __str__(self):
        return f"Year {self.year_number} - {self.program.name}"
    
class Course(models.Model):
    year = models.ForeignKey(Year, related_name='courses', on_delete=models.CASCADE)
    name = models.CharField(max_length=255, unique=True)  

    def __str__(self):
        return self.name



class StudyMaterial(models.Model):
    class MaterialType(models.TextChoices):
        NOTES = 'NOTES', _('Notes')
        PAPERS = 'PAPERS', _('Papers')
        BOOKS = 'BOOKS', _('Books')
        LINKS = 'LINKS', _('Links')
        ASSIGNMENT = 'ASSIGNMENT', _('Assignment')
        LAB = 'LAB', _('Lab')

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)  # Automatically generated unique ID
    type = models.CharField(max_length=20, choices=MaterialType.choices)
    
    # ForeignKey to Course for validation
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='study_materials')
    
    # Store the course name as a string for easier access and filtering
    course_name = models.CharField(max_length=255, editable=False)
    
    title = models.CharField(max_length=255)
    description = models.TextField()

    # FileField for storing file uploads
    file = models.FileField(upload_to=f'study_materials/', null=True, blank=True)

    size = models.CharField(max_length=50, null=True, blank=True, editable=False)

    # List of user IDs who liked the material
    fans = models.JSONField(default=list)
    
    # List of user IDs who disliked the material
    haters = models.JSONField(default=list)
    
    # List of user IDs who reported the material
    reports = models.JSONField(default=list)

    uploaded_at = models.DateTimeField(auto_now_add=True, null=True, editable=False)  # Automatically records the upload date

    def __str__(self):
        return f"{self.title} ({self.course_name})"
    
    def save(self, *args, **kwargs):
        # Automatically set the course_name field to the course's name
        self.course_name = self.course.name

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

    def upvote(self, user_id):
        """Add user to fans list and remove from haters list if present."""
        if user_id not in self.fans:
            self.fans.append(user_id)
        if user_id in self.haters:
            self.haters.remove(user_id)
        self.save()

    def downvote(self, user_id):
        """Add user to haters list and remove from fans list if present."""
        if user_id not in self.haters:
            self.haters.append(user_id)
        if user_id in self.fans:
            self.fans.remove(user_id)
        self.save()

    def delete_vote(self, user_id):
        """Remove user from both fans and haters lists."""
        if user_id in self.fans:
            self.fans.remove(user_id)
        if user_id in self.haters:
            self.haters.remove(user_id)
        self.save()
