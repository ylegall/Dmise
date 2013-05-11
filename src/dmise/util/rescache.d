module dmise.util.rescache;

mixin template ResourceCacheMixin(T, KT=string)
{
  union ResourcePtr
  {
    Resource r;
    int p;
  }

  struct ResourcePionter
  {
    ResourcePtr u;
    bool dead;

    this(Resource r)
    {
      u.r = r;
      u.p ^= -1;
      dead = false;
    }

    Resource get()
    {
      if (dead)
        return null;
      auto rp = u;
      rp.p ^= -1;
      return rp.r;
    }
  }

  protected static ResourcePionter[KT] arr;

  static Resource get(KT k)
  {
    foreach (k2, v; arr)
    {
      if (v.dead)
        arr.remove(k2);
    }

    if (!(k in arr))
      arr[k] = ResourcePionter(loadResource(k));
    return arr[k].get();
  }

  static void forget(KT k)
  {
    arr[k].dead = true;
  }

  mixin template ResourceMixin(T=T,KT=KT)
  {
    T v;
    KT k;

    this(KT k, T v)
    {
      this.k = k;
      this.v = v;
    }

    ~this()
    {
      freeResource(this.v);
      forget(this.k);
    }
  }
}
