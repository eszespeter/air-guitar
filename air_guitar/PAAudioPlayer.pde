import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Environment;
import android.net.Uri;

class PAAudioPlayer extends MediaPlayer {
  PAAudioPlayer() {
  }

  boolean loadFileSDCard(String fileName) {
    String fullPath = Environment.getExternalStorageDirectory().getAbsolutePath();
    fullPath += "/" + fileName;
    return loadFileFullPath(fullPath);
  }

  boolean loadFileDataFolder(String fileName) {
    println("PAAudioPlayer: loading <" + fileName + "> from assets");
    AssetFileDescriptor afd;
    try {
      afd = getAssets().openFd(fileName);
    } catch (IOException e) {
      println("PAAudioPlayer: ERROR loading <" + fileName + "> from assets");
      println(e.getMessage());
      return false;
      // ignore this and move on
      //e.printStackTrace();
    }
    
    if (afd == null) {
      println("PAAudioPlayer: ERROR, asset <" + fileName + "> doesn't exist!");
      return false;
    }
    
    try {
      this.setDataSource(afd.getFileDescriptor(),afd.getStartOffset(),afd.getLength());
      this.setAudioStreamType(AudioManager.STREAM_MUSIC);    // Selects the audio strema for music/media
      this.prepare();
      println("Loaded OK");
      return true;
    } 
    catch (IOException e) {
      println("PAAudioPlayer: error preparing player\n" + e.getMessage());
      println(e.getStackTrace());
      return false;
    }
  }

  boolean loadFileFullPath(String fileName) {
    println("PAAudioPlayer: loading <" + fileName + ">");
    try {
      //this.setDataSource(fileName);
      this.setDataSource(getApplicationContext(), Uri.parse(fileName));
      this.setAudioStreamType(AudioManager.STREAM_MUSIC);    // Selects the audio strema for music/media
      this.prepare();
      println("Loaded OK");
      return true;
    } 
    catch (IOException e) {
      println("PAAudioPlayer: error preparing player\n" + e.getMessage());
      return false;
    }
  }
  
  void reStart() {
    if (this.isPlaying()) {
      this.seekTo(0);
    }
    this.start();
  }
}

