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
    name = models.CharField(max_length=255, unique=True,)  

    def __str__(self):
        return self.name

class Student(models.Model):
    name = models.CharField(max_length=255, unique=True, primary_key=True)
    courses = models.ManyToManyField(Course, related_name="students")
    course_name = models.JSONField(default=list, null=True,)

    def save(self, *args, **kwargs):
        # Store the names of all courses in course_names as a list
        self.course_name = [course.name for course in self.courses.all()]
        super().save(*args, **kwargs)

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
    fans = models.ManyToManyField(Student, related_name="liked_materials", blank=True)
    
    # List of user IDs who disliked the material
    haters = models.ManyToManyField(Student, related_name="disliked_materials", blank=True)
    
    # List of user IDs who reported the material
    reports = models.ManyToManyField(Student, related_name="reported_materials", blank=True)

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

    # def upvote(self, student):
    #     self.haters.remove(student) 
    #     self.fans.add(student)
    #     self.save()
    
    # def downvote(self, student):
    #     self.fans.remove(student)  
    #     self.haters.add(student)
    #     self.save()

    # def report(self, student):
    #     self.reports.add(student)
    #     self.save()
