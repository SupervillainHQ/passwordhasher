package dk.andkrup.util;

import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.ClipboardOwner;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;

public class ClipboardManager implements ClipboardOwner {
	private static ClipboardManager _inst;
	public static ClipboardManager getInstance(){
		if(null==_inst){
			_inst = new ClipboardManager();
		}
		return _inst;
	}
	
	private ClipboardManager(){
	}

	public static void setClipboardContents( String string ){
		Toolkit.getDefaultToolkit().getSystemClipboard().setContents(new StringSelection(string), getInstance() );
	}
	
	public static String getClipboardContents() {
		String result = "";
		Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
		//odd: the Object param of getContents is not currently used
		Transferable contents = clipboard.getContents(null);
		boolean hasTransferableText = (contents != null) && contents.isDataFlavorSupported(DataFlavor.stringFlavor);
		if ( hasTransferableText ) {
			try {
				result = (String)contents.getTransferData(DataFlavor.stringFlavor);
			}
			catch (UnsupportedFlavorException ex){
				//highly unlikely since we are using a standard DataFlavor
				System.out.println(ex);
				ex.printStackTrace();
			}
			catch (IOException ex) {
				System.out.println(ex);
				ex.printStackTrace();
			}
		}
		return result;
	}

	@Override
	public void lostOwnership(Clipboard arg0, Transferable arg1) {
	}
}
