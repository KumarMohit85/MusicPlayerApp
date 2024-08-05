import uuid
from fastapi import APIRouter, Depends, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
import cloudinary
import cloudinary.uploader

from middlewares.auth_middlewares import auth_middleware
from models.song import Song

router = APIRouter()

# Configuration
cloudinary.config(
    cloud_name="dmpqe6ex3",
    api_key="977545198631342",
    # Click 'View Credentials' below to copy your API secret
    api_secret="KO83a63fEVnYeWDNSIT1n6Dcs4Q",
    secure=True
)


@router.post("/upload", status_code=201)
def upload_song(
    song: UploadFile = (...), 
    thumbnail: UploadFile = (...),

    artist: str = Form(...),
    song_name: str = Form(...),
    hex_code: str = Form(),
    db: Session = Depends(get_db), auth_dict=Depends(auth_middleware)

):
   song_id= str(uuid.uuid4())
   song_res = cloudinary.uploader.upload(song.file, resource_type='auto',folder=f'songs/{song_id}')
   print(song_res['url'])
   thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image',folder=f'songs/{song_id}')
   print(thumbnail_res['url'])
   
   new_song = Song(
       id= song_id,
       song_name= song_name,
       artist = artist,
       hex_code= hex_code,
       song_url= song_res['url'],
       thumbnail_url = thumbnail_res['url']
    )
    
   
   db.add(new_song)
   db.commit()
   db.refresh(new_song)
   
   return new_song
   # store db in data
   
@router.get('/list')
def list_songs(db:Session= Depends(get_db),auth_details=Depends(auth_middleware)):
    songs=db.query(Song).all()
    return songs