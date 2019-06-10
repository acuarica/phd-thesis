class Hola {
    void m() {
        theUnsafe = getUnsafe();
        BYTE_ARRAY_BASE_OFFSET = theUnsafe.arrayBaseOffset(byte[].class);
        long l = theUnsafe.getLong(array, (long) offset + BYTE_ARRAY_BASE_OFFSET);


        long address = unsafe.allocateMemory(sizeInByte);
        unsafe.putInt(address, 1);
        unsafe.freeMemory(address);

    }
}